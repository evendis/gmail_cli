# GmailCli [![Build Status](https://secure.travis-ci.org/evendis/gmail_cli.png?branch=master)](http://travis-ci.org/evendis/gmail_cli)

GmailCli packages the key tools and adds a sprinkling of goodness to make it just that much easier
to write primarily command-line utilities for Gmail/GoogleApps.

The primary use-case it currently covers is accessing Gmail (personal and GoogleApps) via IMAP with OAuth2.
It solves the problem of ensuring you keep access credentials refreshed without needing manual intervention,
which is critical if you are building something that is going to run as a scheduled or background process.

This gem doesn't do much of the hard lifting - it is primarily syntactic sugar and packaging for convenience.
The heavy lifting is provided by:
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

There are three basic steps required:

1. Create your API project credentials in the [Google APIs console](https://code.google.com/apis/console/), from the "API Access" tab.

2. Authorize your credentials to access a specific account.
This requires human intervention to explicitly make the approval.
The authorization is typically for a limited time (1 hour).
GmailCli provides a command line utility and set of rake tasks to help you do this.

3. Connect to Gmail which will authenticate your credentials.
GmailCli provides a simple interface to do this, that takes care of resfreshing your credentials
without manual intervention so you don't have to keep going back to step 2 each time your credntials expire.


### How to authorize your OAuth2 credentials - command line approach

    $ gmail_cli authorize

This will prompt you for required information (client_id, client_secret), or you can provide on the command line:

    $ gmail_cli authorize --client_id 'my id' --client_secret 'my secret'


### How to authorize your OAuth2 credentials - Rake approach

In your Rakefile, include the line:

    require 'gmail_cli/tasks'

Then from the command line you can:

    $ rake gmail_cli:authorize

This will prompt you for required information (client_id, client_secret), or you can provide on the command line:

    $ rake gmail_cli:authorize client_id='my id' client_secret='my secret'


### How to get an OAuth2-authorised IMAP connection to Gmail:

    # how you store or set the credentials Hash is up to you, but it should have the following keys:
    credentials = {
      client_id:     'xxxx',
      client_secret: 'yyyy',
      access_token:  'aaaa',
      refresh_token: 'rrrr',
      username:      'name@gmail.com'
    }
    imap = GmailCli.imap_connection(credentials)

On return, <tt>imap</tt> will either be an open Net::IMAP connection, or an error will have been raised. Possible exceptions include:

...


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
