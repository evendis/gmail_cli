require 'spec_helper'

describe GmailCli::Oauth2Helper do
  let(:resource_class) { GmailCli::Oauth2Helper }
  let(:instance) { resource_class.new(options) }
  let(:options) { {} }
  let(:expected) { 'canary' }

  before do
    # silence echo
    resource_class.any_instance.stub(:echo).and_return(nil)
  end

  describe "##authorize!" do
    subject { resource_class.authorize!(options) }
    it "should invoke authorize! on instance" do
      resource_class.any_instance.should_receive(:authorize!).and_return('result!')
      should eql('result!')
    end
  end

  describe "#client_id" do
    subject { instance.client_id }
    it { should be_nil }
    context "when given in options" do
      let(:options) { {client_id: expected} }
      it { should eql(expected) }
    end
  end

  describe "#client_secret" do
    subject { instance.client_secret }
    it { should be_nil }
    context "when given in options" do
      let(:options) { {client_secret: expected} }
      it { should eql(expected) }
    end
  end

  describe "#authorization_code" do
    subject { instance.authorization_code }
    it { should be_nil }
    context "cannot be given in options" do
      let(:options) { {authorization_code: expected} }
      it { should be_nil }
    end
  end

  describe "#access_token" do
    subject { instance.access_token }
    it { should be_nil }
    context "when given in options" do
      let(:options) { {access_token: expected} }
      it { should eql(expected) }
    end
  end

  describe "#refresh_token" do
    subject { instance.refresh_token }
    it { should be_nil }
    context "when given in options" do
      let(:options) { {refresh_token: expected} }
      it { should eql(expected) }
    end
  end

  describe "#scope" do
    subject { instance.scope }
    it { should eql('https://mail.google.com/') }
    context "when given in options" do
      let(:options) { {scope: expected} }
      it { should eql(expected) }
    end
  end

  describe "#redirect_uri" do
    subject { instance.redirect_uri }
    it { should eql('urn:ietf:wg:oauth:2.0:oob') }
    context "when given in options" do
      let(:options) { {redirect_uri: expected} }
      it { should eql(expected) }
    end
  end

  describe "#application_name" do
    subject { instance.application_name }
    it { should eql('gmail_cli') }
    context "when given in options" do
      let(:options) { {application_name: expected} }
      it { should eql(expected) }
    end
  end

  describe "#application_version" do
    subject { instance.application_version }
    it { should eql(GmailCli::VERSION) }
    context "when given in options" do
      let(:options) { {application_version: expected} }
      it { should eql(expected) }
    end
  end

  describe "#ensure_provided" do
    let(:key) { :client_id }
    subject { instance.ensure_provided(key) }
    context "when value already set" do
      let(:options) { {client_id: 'set'} }
      it "should not ask_for_entry when already set" do
        instance.should_receive(:ask_for_entry).never
        subject
      end
    end
    context "when value not already set" do
      it "should ask_for_entry when already set" do
        instance.should_receive(:ask_for_entry).and_return('got it')
        subject
      end
    end
  end

  describe "#authorize!" do
    subject { instance.authorize! }
    it "should get_access_token" do
      instance.should_receive(:get_access_token!).and_return(nil)
      subject
    end
  end

  describe "#api_client" do
    let(:options) { {client_id: 'client_id', client_secret: 'client_secret'} }
    subject { instance.api_client }
    it { should be_a(Google::APIClient) }
  end

  describe "#get_access_token!" do
    let(:options) { {client_id: 'client_id', client_secret: 'client_secret'} }
    let(:mock_access_token) { "ya29.AHES6ZS_KHUpdO5P0nyvADWf4tL5o8e8C_q5UK0HyyYOF3jw" }
    let(:mock_refresh_token) { "ya29.AHES6ZS_KHUpdO5P0nyvADWf4tL5o8e8C_q5UK0HyyYOF3jw" }
    let(:mock_fetch_access_token_response) { {"access_token"=>mock_access_token, "token_type"=>"Bearer", "expires_in"=>3600, "refresh_token"=>mock_refresh_token} }
    subject { instance.get_access_token! }
    it "should orchestrate the fetch_access_token process correctly" do
      instance.api_client.should be_a(Google::APIClient)
      instance.should_receive(:get_authorization_uri).and_return('http://here')
      instance.should_receive(:ensure_provided).with(:authorization_code).and_return('authorization_code')
      instance.should_receive(:fetch_access_token!).and_return(mock_fetch_access_token_response)
      subject.should eql(mock_access_token)
      instance.access_token.should eql(mock_access_token)
      instance.refresh_token.should eql(mock_refresh_token)
    end
  end

  describe "#refresh_access_token!" do
    let(:options) { {client_id: 'client_id', client_secret: 'client_secret', refresh_token: mock_refresh_token} }
    let(:mock_access_token) { "ya29.AHES6ZS_KHUpdO5P0nyvADWf4tL5o8e8C_q5UK0HyyYOF3jw" }
    let(:mock_refresh_token) { "ya29.AHES6ZS_KHUpdO5P0nyvADWf4tL5o8e8C_q5UK0HyyYOF3jw" }
    let(:mock_fetch_refresh_token_response) { {"access_token"=>mock_access_token, "token_type"=>"Bearer", "expires_in"=>3600} }
    subject { instance.refresh_access_token! }
    it "should orchestrate the fetch_access_token process correctly" do
      instance.api_client.should be_a(Google::APIClient)
      instance.should_receive(:fetch_refresh_token!).and_return(mock_fetch_refresh_token_response)
      subject.should eql(mock_access_token)
      instance.access_token.should eql(mock_access_token)
      instance.refresh_token.should eql(mock_refresh_token)
    end
  end


end