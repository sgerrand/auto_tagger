require 'spec_helper'

describe AutoTagger::Configuration do

  before do
    # make sure that the specs don't pick up this gem's .auto_tagger file
    allow(File).to receive(:read) { nil }
  end

  describe "#working_directory" do
    it "returns the current directory when path is nil" do
      dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      allow(Dir).to receive(:pwd) { dir }
      config = AutoTagger::Configuration.new({})
      expect(config.working_directory).to eq(dir)
    end

    it "expands path when path is set" do
      dir = File.expand_path(".")
      config = AutoTagger::Configuration.new :path => "."
      expect(config.working_directory).to eq(dir)
    end
  end

  describe "#opts_file" do
    it "expands the passed in opts file path in reference to the working directory" do
      config = AutoTagger::Configuration.new :opts_file => "../.foo_tagger", :path => "/foo/bar"
      expect(config.opts_file).to eq("/foo/.foo_tagger")
    end

    it "defaults to looking in the working directories .auto_tagger file" do
      config = AutoTagger::Configuration.new :path => "/foo"
      expect(config.opts_file).to eq("/foo/.auto_tagger")
    end
  end

  describe "#file_settings" do
    it "return a hash representing the options specified in the opts file" do
      config = AutoTagger::Configuration.new
      allow(config).to receive(:opts_file) { "/foo/.auto_tagger" }
      expect(File).to receive(:exists?) { true }
      expect(File).to receive(:read).with("/foo/.auto_tagger").and_return("--offline=false\n--verbose=true")
      expect(config.file_settings).to eq({:offline => false, :verbose => true})
    end

    it "ignores blank lines and whitespace" do
      config = AutoTagger::Configuration.new
      allow(config).to receive(:opts_file) { "/foo/.auto_tagger" }
      expect(File).to receive(:exists?).with("/foo/.auto_tagger") { true }
      expect(File).to receive(:read).with("/foo/.auto_tagger").and_return("  --offline=false  \n\n--verbose=true\n")
      expect(config.file_settings).to eq({:offline => false, :verbose => true})
    end

    it "returns an empty hash if the file doens't exist" do
      allow(File).to receive(:exists?) { false }
      config = AutoTagger::Configuration.new :path => "/foo"
      expect(config.file_settings).to eq({})
    end

    # TODO: print warnings instead of blowing up??
    it "doesn't parse options that are not valid for the opts file" do
      allow(File).to receive(:exists?) { true }
      expect(File).to receive(:read).with("/foo/.auto_tagger").and_return("--opts-file=/foo")
      config = AutoTagger::Configuration.new :path => "/foo"
      expect do
        expect(config.file_settings).to eq({})
      end.to raise_error(OptionParser::InvalidOption)
    end
  end

  describe "#settings" do
    it "should merge the passed in settings with the file settings" do
      config = AutoTagger::Configuration.new :stage => "demo", :offline => true
      allow(config).to receive(:file_settings).and_return({:stage => "ci", :verbose => false})
      expect(config.settings).to eq({:stage => "demo", :offline => true, :verbose => false})
    end
  end

  describe "#stages" do
    it "splits on a comma if it's a string, ignoring whitespace" do
      config = AutoTagger::Configuration.new :stages => ",ci,, demo ,  production,"
      expect(config.stages).to eq(["ci", "demo", "production"])
    end

    it "returns the passed in stages if it's an array" do
      config = AutoTagger::Configuration.new :stages => ["ci", "demo"]
      expect(config.stages).to eq(["ci", "demo"])
    end

    it "removes blank items" do
      config = AutoTagger::Configuration.new :stages => ["ci", ""]
      expect(config.stages).to eq(["ci"])
    end

    it "turns stages into strings" do
      config = AutoTagger::Configuration.new :stages => [:ci, :production]
      expect(config.stages).to eq(["ci", "production"])
    end
  end

  describe "#stage" do
    it "should use the stage passed in" do
      config = AutoTagger::Configuration.new :stage => "demo"
      expect(config.stage).to eq("demo")
    end

    it "defaults to the last stage if stages is passed in" do
      config = AutoTagger::Configuration.new :stages => ["demo", "production"]
      expect(config.stage).to eq("production")
    end

    it "returns nil if stage and stages are not passed in" do
      config = AutoTagger::Configuration.new
      expect(config.stage).to be_nil
    end

    it "stringifies the passed in stage" do
      config = AutoTagger::Configuration.new :stage => :demo
      expect(config.stage).to eq("demo")
    end
  end

  describe "#date_separator" do
    it "returns the passed in option" do
      config = AutoTagger::Configuration.new :date_separator => "-"
      expect(config.date_separator).to eq("-")
    end

    it "defaults to an empty string" do
      config = AutoTagger::Configuration.new
      expect(config.date_separator).to eq("")
    end
  end

  describe "#dry_run?" do
    it "returns the passed in option" do
      config = AutoTagger::Configuration.new :dry_run => true
      expect(config.dry_run?).to eq(true)

      config = AutoTagger::Configuration.new :dry_run => false
      expect(config.dry_run?).to eq(false)
    end

    it "defaults to false" do
      config = AutoTagger::Configuration.new
      expect(config.dry_run?).to eq(false)
    end
  end

  describe "#verbose?" do
    it "returns the passed in option" do
      config = AutoTagger::Configuration.new :verbose => true
      expect(config.verbose?).to eq(true)

      config = AutoTagger::Configuration.new :verbose => false
      expect(config.verbose?).to eq(false)
    end

    it "defaults to false" do
      config = AutoTagger::Configuration.new
      expect(config.verbose?).to eq(false)
    end
  end

  describe "#offline?" do
    it "returns the passed in option" do
      config = AutoTagger::Configuration.new :offline => true
      expect(config.offline?).to eq(true)

      config = AutoTagger::Configuration.new :offline => false
      expect(config.offline?).to eq(false)
    end

    it "defaults to false" do
      config = AutoTagger::Configuration.new
      expect(config.offline?).to eq(false)
    end
  end

  describe "#push_refs" do
    it "defaults to true" do
      config = AutoTagger::Configuration.new
      expect(config.push_refs?).to eq(true)
    end

    it "respects the passed-in option" do
      config = AutoTagger::Configuration.new :push_refs => true
      expect(config.push_refs?).to eq(true)

      config = AutoTagger::Configuration.new :push_refs => false
      expect(config.push_refs?).to eq(false)
    end

    it "returns false if offline is true" do
      config = AutoTagger::Configuration.new :offline => true, :push_refs => true
      expect(config.push_refs?).to eq(false)
    end
  end

  describe "#fetch_refs" do
    it "defaults to true" do
      config = AutoTagger::Configuration.new
      expect(config.fetch_refs?).to eq(true)
    end

    it "respects the passed-in option" do
      config = AutoTagger::Configuration.new :fetch_refs => true
      expect(config.fetch_refs?).to eq(true)

      config = AutoTagger::Configuration.new :fetch_refs => false
      expect(config.fetch_refs?).to eq(false)
    end

    it "returns false if offline is true" do
      config = AutoTagger::Configuration.new :offline => true, :fetch_refs => true
      expect(config.fetch_refs?).to eq(false)
    end
  end

  describe "#executable" do
    it "returns the passed in executable" do
      config = AutoTagger::Configuration.new :executable => "/usr/bin/git"
      expect(config.executable).to eq("/usr/bin/git")
    end

    it "defaults to git" do
      config = AutoTagger::Configuration.new
      expect(config.executable).to eq("git")
    end
  end

  describe "#refs_to_keep" do
    it "return the refs to keep" do
      config = AutoTagger::Configuration.new :refs_to_keep => 4
      expect(config.refs_to_keep).to eq(4)
    end

    it "defaults to 1" do
      config = AutoTagger::Configuration.new
      expect(config.refs_to_keep).to eq(1)
    end

    it "always returns a FixNum" do
      config = AutoTagger::Configuration.new :refs_to_keep => "4"
      expect(config.refs_to_keep).to eq(4)
    end
  end

  describe "#remote" do
    it "returns the passed in option" do
      config = AutoTagger::Configuration.new :remote => "myorigin"
      expect(config.remote).to eq("myorigin")
    end

    it "defaults to origin" do
      config = AutoTagger::Configuration.new
      expect(config.remote).to eq("origin")
    end
  end

  describe "#ref_path" do
    it "returns the passed in option" do
      config = AutoTagger::Configuration.new :ref_path => "auto_tags"
      expect(config.ref_path).to eq("auto_tags")
    end

    it "defaults to tags" do
      config = AutoTagger::Configuration.new
      expect(config.ref_path).to eq("tags")
    end

    it "raises an error if you pass in heads or remotes" do
      expect do
        config = AutoTagger::Configuration.new :ref_path => "heads"
        expect(config.ref_path).to eq("tags")
      end.to raise_error(AutoTagger::Configuration::InvalidRefPath)

      expect do
        config = AutoTagger::Configuration.new :ref_path => "heads"
        expect(config.ref_path).to eq("tags")
      end.to raise_error(AutoTagger::Configuration::InvalidRefPath)
    end
  end

end
