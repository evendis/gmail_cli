require 'spec_helper'

describe GmailCli do
  let(:options) { {} }

  describe "##imap_connection" do
    subject { GmailCli.imap_connection(options) }
    it "returns a connected GmailCli::Imap" do
      expect_any_instance_of(GmailCli::Imap).to receive(:connect!).and_return('result!')
      expect(subject).to eql('result!')
    end
  end

  describe "::Imap" do
    let(:imap) { GmailCli::Imap.new(options) }
    subject { imap }
    it "has the expected default settings" do
      expect(subject.username).to be_nil
      expect(subject.host).to eql('imap.gmail.com')
      expect(subject.host_options).to eql({port: 993, ssl: true})
    end

    describe "#username" do
      let(:expected) { 'test@test.com' }
      let(:options) { {username: expected} }
      it "can be set through options" do
        expect(subject.username).to eql(expected)
      end
    end

    describe "#host" do
      let(:expected) { 'test.com' }
      let(:options) { {host: expected} }
      it "can be set through options" do
        expect(subject.host).to eql(expected)
      end
    end

    describe "#host_options" do
      let(:expected) { {port: 111} }
      let(:options) { {host_options: expected} }
      it "can be set through options" do
        expect(subject.host_options).to eql(expected)
      end
    end

    describe "#oauth_options" do
      it "is all nil by default" do
        expect(subject.oauth_options).to eql({
          client_id: nil,
          client_secret: nil,
          access_token: nil,
          refresh_token: nil
        })
      end
      context "when some given in options" do
        let(:options) { {client_id: 'abcd'} }
        it "sets selected items correctly" do
          expect(subject.oauth_options).to eql({
            client_id: 'abcd',
            client_secret: nil,
            access_token: nil,
            refresh_token: nil
          })
        end
      end
      context "when all given in options" do
        let(:options) { {client_id: 'abcd', client_secret: 'efg', access_token: '123', refresh_token: '456'} }
        it "sets all items correctly" do
          expect(subject.oauth_options).to eql({
          client_id: 'abcd',
          client_secret: 'efg',
          access_token: '123',
          refresh_token: '456'
          })
          expect(subject.options.keys).to_not include(:client_id)
          expect(subject.oauth_access_token).to eql('123')
        end
      end
    end

  end

end

