require 'spec_helper'

describe "Rake Task gmail_cli:" do
  require 'rake'
  require 'gmail_cli/tasks'

  describe "authorize" do
    let(:task_name) { "gmail_cli:authorize" }
    let :run_rake_task do
      Rake::Task[task_name].reenable
      Rake.application.invoke_task task_name
    end

    it "should run successfully" do
      GmailCli::Oauth2Helper.any_instance.should_receive(:authorize!).and_return(nil)
      expect { run_rake_task }.to_not raise_error
    end

  end

end