require 'spec_helper'

describe GmailCli::Logger do
  let(:logger) { GmailCli::Logger }
  let(:trace_something) { logger.trace 'somthing', 'bogative' }

  it "does not log when verbose mode not enabled" do
    expect($stderr).to receive(:puts).never
    trace_something
  end

  it "logs when verbose mode enabled" do
    logger.set_log_mode(true)
    expect($stderr).to receive(:puts).and_return(nil)
    trace_something
    logger.set_log_mode(false)
  end

  it "does not log when verbose mode enabled then disabled" do
    logger.set_log_mode(true)
    logger.set_log_mode(false)
    expect($stderr).to receive(:puts).never
    trace_something
  end

end