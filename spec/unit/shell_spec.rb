require 'spec_helper'
require 'getoptions'

describe GmailCli::Shell do

  let(:getoptions) { GetOptions.new(GmailCli::Shell::OPTIONS, options) }
  let(:shell) { GmailCli::Shell.new(getoptions,argv) }

  before do
    $stderr.stub(:puts) # silence console feedback chatter
  end

  describe "#usage" do
    let(:options) { ['-h'] }
    let(:argv) { [] }
    it "should print usage when run" do
      shell.should_receive(:usage)
      shell.run
    end
  end

end