require 'spec_helper'
require 'getoptions'

describe GmailCli::Shell do

  let(:getoptions) { GetOptions.new(GmailCli::Shell::OPTIONS, options) }
  let(:shell) { GmailCli::Shell.new(getoptions,argv) }

  before do
    allow($stderr).to receive(:puts) # silence console feedback chatter
  end

  describe "#usage" do
    let(:options) { ['-h'] }
    let(:argv) { [] }
    it "prints usage when run" do
      expect(shell).to receive(:usage)
      shell.run
    end
  end

  describe "#authorize" do
    let(:options) { [] }
    let(:argv) { ["authorize"] }
    it "should invoke authorize when run" do
      expect(GmailCli::Oauth2Helper).to receive(:authorize!)
      shell.run
    end
  end

end