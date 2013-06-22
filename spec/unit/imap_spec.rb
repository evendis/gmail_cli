require 'spec_helper'

describe GmailCli do
  let(:options) { {} }

  describe "##imap_connection" do
    subject { GmailCli.imap_connection(options) }
    it "should return connected GmailCli::Imap" do
      GmailCli::Imap.any_instance.should_receive(:connect!).and_return('result!')
      should eql('result!')
    end
  end

  describe "::Imap" do
    let(:imap) { GmailCli::Imap.new(options) }
    subject { imap }

    describe "#username" do
      subject { imap.username }
      it { should be_nil }
      context "when given in options" do
        let(:expected) { 'test@test.com' }
        let(:options) { {username: expected} }
        it { should eql(expected) }
      end
    end

    describe "#host" do
      subject { imap.host }
      it { should eql('imap.gmail.com') }
      context "when given in options" do
        let(:expected) { 'test.com' }
        let(:options) { {host: expected} }
        it { should eql(expected) }
      end
    end

    describe "#host_options" do
      subject { imap.host_options }
      it { should eql({port: 993, ssl: true}) }
      context "when given in options" do
        let(:expected) { {port: 111} }
        let(:options) { {host_options: expected} }
        it { should eql(expected) }
      end
    end

    describe "#oauth_options" do
      subject { imap.oauth_options }
      it { should eql({
        client_id: nil,
        client_secret: nil,
        access_token: nil,
        refresh_token: nil
      }) }
      context "when some given in options" do
        let(:options) { {client_id: 'abcd'} }
        it { should eql({
          client_id: 'abcd',
          client_secret: nil,
          access_token: nil,
          refresh_token: nil
        }) }
      end
      context "when all given in options" do
        let(:options) { {client_id: 'abcd', client_secret: 'efg', access_token: '123', refresh_token: '456'} }
        it { should eql({
          client_id: 'abcd',
          client_secret: 'efg',
          access_token: '123',
          refresh_token: '456'
        }) }
        it "should not be included in the options" do
          imap.options.keys.should_not include(:client_id)
        end
        describe "#oauth_access_token" do
          subject { imap.oauth_access_token }
          it { should eql('123') }
        end
      end
    end



  end

end

