require 'net/imap'
require 'net/http'
require 'uri'
require 'gmail_xoauth'

module GmailCli

  # Command: convenience method to return IMAP connection given +options+
  def self.imap_connection(options={})
    GmailCli::Imap.new(options).connect!
  end

  class Imap
    include GmailCli::LoggerSupport

    attr_accessor :imap, :options, :oauth_options

    def initialize(options={})
      options = options.dup
      @oauth_options = {
        client_id: options.delete(:client_id),
        client_secret: options.delete(:client_secret),
        access_token: options.delete(:access_token),
        refresh_token: options.delete(:refresh_token)
      }
      @options = {
        host: 'imap.gmail.com'
      }.merge(options)
      @options[:host_options] ||= {
        port: 993,
        ssl: true
      }
    end

    def refresh_access_token!
      oauth_options[:access_token] = GmailCli::Oauth2Helper.new(oauth_options).refresh_access_token!
    end

    def host
      options[:host]
    end
    def username
      options[:username]
    end
    def host_options
      options[:host_options]
    end
    def oauth_access_token
      oauth_options[:access_token]
    end

    def connect!
      disconnect!
      refresh_access_token! # we cheat a bit here - refreshing the token every time we get a new connection
      trace "#{__method__} to host", host
      self.imap = Net::IMAP.new(host,host_options)
      trace "imap capabilities", imap.capability
      imap.authenticate('XOAUTH2', username, oauth_access_token)
      imap
    end

    def disconnect!
      return unless imap
      trace "calling", __method__
      imap.close
      self.imap = nil
    rescue Exception => e
      trace "#{__method__} error", e
    end
  end

end