# GmailCli

GmailCli packages the key tools and adds a sprinkling of goodness to make it just that much easier
to write primarily command-line utilities for Gmail/GoogleApps.

The primary use-case it currently covers is accessing Gmail (personal and GoogleApps) via IMAP with OAuth2.

This gem doesn't do much of the hard lifting - it is primarily syntactic sugar and packaging for convenience.
the heavy lifting is included from:
* [gmail_xoauth](https://github.com/nfo/gmail_xoauth) which provides OAuth2 support for Google IMAP and SMTP
* [google-api-ruby-client](https://github.com/google/google-api-ruby-client) which is the official Google API gem providing OAuth2 utilities


## Installation

Add this line to your application's Gemfile:

    gem 'gmail_cli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gmail_cli

## Usage

### How to authenticate your OAuth2 credentials - command line approach

  $ gmail_cli authenticate

### How to authenticate your OAuth2 credentials - rake approach

In your Rakefile, include the line:

  require 'gmail_cli/tasks'

Then from the command ine you can:

  $ rake gmail_cli:authenticate


### How to get an OAuth2-authorised IMAP connection to Gmail:

  # how you store or set the credntials Hash is up to you, but it should have the following keys:
  credentials = {
    client_id: 'xxxx',
    client_secret: 'yyyy',
    refresh_token: 'zzzz'
  }
  imap = GmailCli.imap(credentials)

On return, <tt>imap</tt> will either be an open Net::IMAP connection, or an error will have been raised. Possible exceptions include:


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
