require 'google/api_client'

class GmailCli::Oauth2Helper

  class << self
    # Command: convenience class method to invoke authorization phase
    def authorize!(options={})
      new(options).authorize!
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
  end

  def echo(text)
    puts text
  end

  def authorize!
    echo %(
Performing Google OAuth2 client authorization
---------------------------------------------)
    get_access_token
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

  def get_access_token
    # Request authorization
    authorization_uri = api_client.authorization.authorization_uri
    echo %(
Go to the following URL in a web browser to grant the authorization.
There you will be able to select specifically which gmail account the authorization is for.

  #{authorization_uri}

When you have done that successfully it will provide a code to enter here:
)
    api_client.authorization.code = ensure_provided(:authorization_code)
    response = api_client.authorization.fetch_access_token!
    self.access_token = response['access_token']
    self.refresh_token = response['refresh_token']
    echo %(
Response: #{response.inspect}

Authorization was successful! You can now use this credential to access gmail.

For example, to get an authenticated IMAP connection:

  credentials = {
    client_id: '#{client_id}',
    client_secret: '#{client_secret}',
    refresh_token: '#{refresh_token}'
  }
  imap = GmailCli.imap_connection(credentials)

)
  end

  def ensure_provided(key)
    eval("self.#{key} ||= ask_for_entry('#{key}: ')")
  end

  def ask_for_entry(prompt)
    print prompt
    STDIN.gets.chomp!
  end
end
