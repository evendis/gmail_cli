# class that groks the command line options and invokes the required task
class GmailCli::Shell

  # holds the parsed options
  attr_reader :options

  # holds the remaining command line arguments
  attr_reader :args

  # initializes the shell with command line argments:
  #
  # +options+ is expected to be the hash structure as provided by GetOptions.new(..)
  #
  # +args+ is the remaining command line arguments
  #
  def initialize(options,args)
    @options = (options||{}).each{|k,v| {k => v} }
    @args = args
    GmailCli::Logger.set_log_mode(options[:verbose])
  end

  # Command: execute the task according to the options provided on initialisation
  def run
    case
    when args.first =~ /authorize/i
      authorize
    else
      usage
    end
  end

  # defines the valid command line options
  OPTIONS = %w(help verbose client_id:s client_secret:s)

  class << self

    # prints usage/help information
    def usage
      $stderr.puts <<-EOS

GmailCli v#{GmailCli::VERSION}
===================================

Usage:
  gmail_cli [options] [commands]

Options:
  -h  | --help           : shows command help
  -v  | --verbose        : run with verbose

  --client_id "xxxx"     : OAuth2 client_id
  --client_secret "yyy"  : OAuth2 client_secret

Commands:
  authorize              : perform Google OAuth2 client authorization


EOS
    end
  end

  # prints usage/help information
  def usage
    self.class.usage
  end

  def authorize
    GmailCli::Oauth2Helper.authorize!(options)
  end

end