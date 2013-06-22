require 'google/api_client'

class GmailCli::Oauth2Helper
  include GmailCli::LoggerSupport

  class << self
    # Command: convenience class method to invoke authorization phase
    def authorize!(options={})
      new(options).authorize!
    rescue Interrupt
      $stderr.puts "..interrupted."
    end
  end

  attr_accessor :client_id, :client_secret
  attr_accessor :authorization_code, :access_token, :refresh_token
  attr_accessor :scope, :redirect_uri, :application_name, :application_version

  def initialize(options={})
    @client_id = options[:client_id]
    @client_secret = options[:client_secret]
    @access_token = options[:access_token]
    @refresh_token = options[:refresh_token]
    @scope = options[:scope] || 'https://mail.google.com/'
    @redirect_uri = options[:redirect_uri] || 'urn:ietf:wg:oauth:2.0:oob'
    @application_name = options[:application_name] || 'gmail_cli'
    @application_version = options[:application_version] || GmailCli::VERSION
    trace "#{self.class.name} resolved options", {
      client_id: client_id, client_secret: client_secret,
      access_token: access_token, refresh_token: refresh_token,
      scope: scope, redirect_uri: redirect_uri,
      application_name: application_name, application_version: application_version
    }
  end

  def echo(text)
    puts text
  end

  # Command: requests and returns a fresh access_token
  def refresh_access_token!
    api_client.authorization.refresh_token = refresh_token
    response = fetch_refresh_token!
    # => {"access_token"=>"ya29.AHES6ZRclrR13BePPwPmwdPUtoVqRxJ4fyVKgN1LJzIg-f8", "token_type"=>"Bearer", "expires_in"=>3600}
    trace "#{__method__} response", response
    self.access_token = response['access_token']
  end

  # Command: runs an interactive authorization phase
  def authorize!
    echo %(
Performing Google OAuth2 client authorization
---------------------------------------------)
    get_access_token!
  end

  def api_client
    @api_client ||= if ensure_provided(:client_id) && ensure_provided(:client_secret) && ensure_provided(:redirect_uri) && ensure_provided(:scope)
      # Initialize OAuth 2.0 client
      api_client = Google::APIClient.new(application_name: application_name, application_version: application_version)
      api_client.authorization.client_id = client_id
      api_client.authorization.client_secret = client_secret
      api_client.authorization.redirect_uri = redirect_uri
      api_client.authorization.scope = scope
      api_client
    end
  end

  def get_access_token!
    # Request authorization
    authorization_uri = get_authorization_uri
    echo %(
Go to the following URL in a web browser to grant the authorization.
There you will be able to select specifically which gmail account the authorization is for.

  #{authorization_uri}

When you have done that successfully it will provide a code to enter here:
)
    api_client.authorization.code = ensure_provided(:authorization_code)
    response = fetch_access_token!
    # => {"access_token"=>"ya29.AHES6ZS_KHUpdO5P0nyvADWf4tL5o8e8C_q5UK0HyyYOF3jw", "token_type"=>"Bearer", "expires_in"=>3600, "refresh_token"=>"1/o4DFZX1_iu_riPiu-OO6FLJ9M8pE5QWmY5DDoUHyOGw"}
    trace "#{__method__} response", response
    self.access_token = response['access_token']
    self.refresh_token = response['refresh_token']
    echo %(
Authorization was successful! You can now use this credential to access gmail.

For example, to get an authenticated IMAP connection to the 'name@gmail.com' account:

  credentials = {
    client_id:     '#{client_id}',
    client_secret: '#{client_secret}',
    access_token:  '#{access_token}',
    refresh_token: '#{refresh_token}',
    username:      'name@gmail.com'
  }
  imap = GmailCli.imap_connection(credentials)

)
    access_token
  end

  def get_authorization_uri
    api_client.authorization.authorization_uri
  end

  def fetch_access_token!
    api_client.authorization.fetch_access_token!
  end

  def fetch_refresh_token!
    api_client.authorization.refresh!
  end

  def ensure_provided(key)
    eval("self.#{key} ||= ask_for_entry('#{key}: ')")
  end

  def ask_for_entry(prompt)
    print prompt
    STDIN.gets.chomp!
  end
end
