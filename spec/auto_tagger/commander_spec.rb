require 'spec_helper'

describe AutoTagger::Commander do

  describe "#read" do
    it "execute the command and returns the results" do
      commander = AutoTagger::Commander.new("/foo", false)
      expect(commander).to receive(:`).with('cd "/foo" && ls')
      commander.read("ls")
    end

    it "puts the response when it's verbose" do
      commander = AutoTagger::Commander.new("/foo", true)
      allow(commander).to receive(:`)
      expect(commander).to receive(:puts).with('cd "/foo" && ls')
      commander.read("ls")
    end
  end

  describe "#execute" do
    it "executes and doesn't return anything" do
      commander = AutoTagger::Commander.new("/foo", false)
      expect(commander).to receive(:system).with('cd "/foo" && ls')
      commander.execute("ls")
    end

    it "puts the response when it's verbose" do
      commander = AutoTagger::Commander.new("/foo", true)
      allow(commander).to receive(:system)
      expect(commander).to receive(:puts).with('cd "/foo" && ls')
      commander.execute("ls")
    end
  end

  describe "#print" do
    it "returns the command to be run" do
      commander = AutoTagger::Commander.new("/foo", false)
      expect(commander).to receive(:puts).with('cd "/foo" && ls')
      commander.print("ls")
    end
  end

end
