namespace :gmail_cli do
  require 'gmail_cli'

  desc "Perform Google OAuth2 client authorization with client_id=? client_secret=?"
  task :authorize do |t|
    options = {
      client_id: ENV['client_id'],
      client_secret: ENV['client_secret'],
      scope: ENV['scope'],
      redirect_uri: ENV['redirect_uri'],
      application_name: ENV['application_name'],
      application_version: ENV['application_version']
    }
    GmailCli::Oauth2Helper.authorize!(options)
  end

end
