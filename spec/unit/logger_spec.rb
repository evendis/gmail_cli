require 'spec_helper'

describe GmailCli::Logger do
  let(:logger) { GmailCli::Logger }
  let(:trace_something) { logger.trace 'somthing', 'bogative' }

  it "should not log when verbose mode not enabled" do
    $stderr.should_receive(:puts).never
    trace_something
  end

  it "should log when verbose mode enabled" do
    logger.set_log_mode(true)
    $stderr.should_receive(:puts).and_return(nil)
    trace_something
    logger.set_log_mode(false)
  end

  it "should not log when verbose mode enabled then disabled" do
    logger.set_log_mode(true)
    logger.set_log_mode(false)
    $stderr.should_receive(:puts).never
    trace_something
  end

end