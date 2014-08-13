require 'spec_helper'

describe AutoTagger::CommandLine do

  describe "#execute" do
    it "runs the version command" do
      command_line = AutoTagger::CommandLine.new ["version"]
      expect(command_line.execute.first).to eq(true)
      expect(command_line.execute.last).to include(AutoTagger::VERSION)
    end

    it "runs the help command" do
      command_line = AutoTagger::CommandLine.new ["help"]
      expect(command_line.execute.last).to include("USAGE")
    end

    describe "#cleanup" do
      it "runs the cleanup command with a stage" do
        command_line = AutoTagger::CommandLine.new ["cleanup"]
        tagger = double(AutoTagger::Base, :cleanup => 7)
        expect(AutoTagger::Base).to receive(:new).and_return(tagger)
        expect(command_line.execute.last).to include("7")
      end

      it "prints a friendly error message when no stage is provided" do
        command_line = AutoTagger::CommandLine.new ["cleanup"]
        expect(AutoTagger::Base).to receive(:new).and_raise(AutoTagger::Base::StageCannotBeBlankError)
        expect(command_line.execute.last).to include("You must provide a stage")
      end
    end

    describe "#delete_locally" do
      it "runs the delete_locally command" do
        command_line = AutoTagger::CommandLine.new ["delete_locally"]
        tagger = double(AutoTagger::Base, :delete_locally => 7)
        expect(AutoTagger::Base).to receive(:new).and_return(tagger)
        expect(command_line.execute.last).to include("7")
      end

      it "prints a friendly error message when no stage is provided" do
        command_line = AutoTagger::CommandLine.new ["delete_locally"]
        expect(AutoTagger::Base).to receive(:new).and_raise(AutoTagger::Base::StageCannotBeBlankError)
        expect(command_line.execute.last).to include("You must provide a stage")
      end
    end

    describe "#delete_on_remote" do
      it "runs the delete_on_remote command" do
        command_line = AutoTagger::CommandLine.new ["delete_on_remote"]
        tagger = double(AutoTagger::Base, :delete_on_remote => 7)
        expect(AutoTagger::Base).to receive(:new).and_return(tagger)
        expect(command_line.execute.last).to include("7")
      end

      it "prints a friendly error message when no stage is provided" do
        command_line = AutoTagger::CommandLine.new ["delete_on_remote"]
        expect(AutoTagger::Base).to receive(:new).and_raise(AutoTagger::Base::StageCannotBeBlankError)
        expect(command_line.execute.last).to include("You must provide a stage")
      end
    end

    describe "#list" do
      it "runs the list command" do
        command_line = AutoTagger::CommandLine.new ["list"]
        tagger = double(AutoTagger::Base, :list => ["foo", "bar"])
        expect(AutoTagger::Base).to receive(:new).and_return(tagger)
        expect(command_line.execute.last).to include("foo", "bar")
      end

      it "prints a friendly error message when no stage is provided" do
        command_line = AutoTagger::CommandLine.new ["list"]
        expect(AutoTagger::Base).to receive(:new).and_raise(AutoTagger::Base::StageCannotBeBlankError)
        expect(command_line.execute.last).to include("You must provide a stage")
      end
    end

    it "runs the config command" do
      command_line = AutoTagger::CommandLine.new ["config"]
      config = double(AutoTagger::Configuration, :settings => {"foo" =>  "bar"})
      expect(AutoTagger::Configuration).to receive(:new).and_return(config)
      expect(command_line.execute.last).to include("foo", "bar")
    end

    describe "#create" do
      it "runs the create command" do
        command_line = AutoTagger::CommandLine.new ["create"]
        tagger = double(AutoTagger::Base, :create_ref => double(AutoTagger::Git::Ref, :name => "refs/tags"))
        expect(AutoTagger::Base).to receive(:new).and_return(tagger)
        expect(command_line.execute.last).to include("refs/tags")
      end

      it "includes a deprecation command when necessary" do
        command_line = AutoTagger::CommandLine.new ["ci"]
        tagger = double(AutoTagger::Base, :create_ref => double(AutoTagger::Git::Ref, :name => "refs/tags"))
        expect(AutoTagger::Base).to receive(:new).and_return(tagger)
        result = command_line.execute.last
        expect(result).to include("DEPRECATION")
        expect(result).to include("refs/tags")
      end

      it "prints a friendly error message when no stage is provided" do
        command_line = AutoTagger::CommandLine.new ["create"]
        expect(AutoTagger::Base).to receive(:new).and_raise(AutoTagger::Base::StageCannotBeBlankError)
        expect(command_line.execute.last).to include("You must provide a stage")
      end
    end

  end

end
