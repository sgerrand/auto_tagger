require 'spec_helper'

describe AutoTagger::CapistranoHelper do

  describe "#ref" do
    it "returns the specified branch when passed the :head variable" do
      helper = AutoTagger::CapistranoHelper.new :branch => "release", :head => nil
      expect(helper.ref).to eq("release")
    end

    it "returns the specified tag" do
      helper = AutoTagger::CapistranoHelper.new :tag => "v0.1.7"
      expect(helper.ref).to eq("v0.1.7")
    end

    it "returns the specified ref" do
      helper = AutoTagger::CapistranoHelper.new :ref => "refs/auto_tags/ci"
      expect(helper.ref).to eq("refs/auto_tags/ci")
    end

    it "returns the sha of the last ref from that stage" do
      helper = AutoTagger::CapistranoHelper.new({})
      ref = double(AutoTagger::Git::Ref, :sha => "abc123")
      auto_tagger = double AutoTagger::Base, :last_ref_from_previous_stage => ref
      allow(helper).to receive(:auto_tagger) { auto_tagger }
      expect(helper.ref).to eq("abc123")
    end

    it "returns the branch when specified" do
      helper = AutoTagger::CapistranoHelper.new :branch => "release"
      expect(helper.ref).to eq("release")
    end
  end

  describe "#auto_tagger" do
    it "returns an AutoTagger::Base object with the correct options" do
      helper = AutoTagger::CapistranoHelper.new({})
      allow(helper).to receive(:auto_tagger_options).and_return({:foo => "bar"})
      expect(AutoTagger::Base).to receive(:new).with({:foo => "bar"})
      helper.auto_tagger
    end
  end

  describe "#auto_tagger_options" do
    it "includes :stage from :auto_tagger_stage, :stage" do
      helper = AutoTagger::CapistranoHelper.new :stage => "demo"
      expect(helper.auto_tagger_options[:stage]).to eq("demo")

      helper = AutoTagger::CapistranoHelper.new :auto_tagger_stage => "demo"
      expect(helper.auto_tagger_options[:stage]).to eq("demo")

      helper = AutoTagger::CapistranoHelper.new :auto_tagger_stage => "demo", :stage => "ci"
      expect(helper.auto_tagger_options[:stage]).to eq("demo")
    end

    it "includes stages" do
      helper = AutoTagger::CapistranoHelper.new :auto_tagger_stages => ["demo"]
      expect(helper.auto_tagger_options[:stages]).to eq(["demo"])
    end

    it "includes :auto_tagger_working_directory" do
      helper = AutoTagger::CapistranoHelper.new :auto_tagger_working_directory => "/foo"
      expect(helper.auto_tagger_options[:path]).to eq("/foo")
    end

    it "includes and deprecates :working_directory" do
      expect(AutoTagger::Deprecator).to receive(:warn)
      helper = AutoTagger::CapistranoHelper.new :working_directory => "/foo"
      expect(helper.auto_tagger_options[:path]).to eq("/foo")
    end

    [
      :date_separator,
      :push_refs,
      :fetch_refs,
      :remote,
      :ref_path,
      :offline,
      :dry_run,
      :verbose,
      :refs_to_keep,
      :executable,
      :opts_file
    ].each do |key|
      it "includes :#{key} when specified" do
        helper = AutoTagger::CapistranoHelper.new({})
        expect(helper.auto_tagger_options).not_to have_key(key)

        helper = AutoTagger::CapistranoHelper.new(:"auto_tagger_#{key}" => "value")
        expect(helper.auto_tagger_options).to have_key(key)
        expect(helper.auto_tagger_options[key]).to eq("value")
      end
    end

    it "accepts capistrano's dry_run" do
      expect(AutoTagger::CapistranoHelper.new(:dry_run => "shazbot").auto_tagger_options[:dry_run]).to eq("shazbot")
    end

    [
      [nil, nil, nil],
      [true, nil, true],
      [false, nil, false],

      [nil, false, false],
      [true, false, false],
      [false, false, false],

      [nil, true, true],
      [true, true, true],
      [false, true, true],
    ].each do |dry_run, auto_tagger_dry_run, preferred|
      it "prefers auto_tagger_dry_run=#{auto_tagger_dry_run.inspect} to dry_run=#{dry_run.inspect}" do
        helper = AutoTagger::CapistranoHelper.new(:dry_run => dry_run, :auto_tagger_dry_run => auto_tagger_dry_run)
        expect(helper.auto_tagger_options[:dry_run]).to eq(preferred)
      end
    end
  end

  describe "#stages" do
    it "understands :stages" do
      helper = AutoTagger::CapistranoHelper.new :stages => ["demo"]
      expect(helper.stages).to eq(["demo"])
    end

    it "understands :auto_tagger_stages" do
      helper = AutoTagger::CapistranoHelper.new :auto_tagger_stages => ["demo"]
      expect(helper.auto_tagger_options[:stages]).to eq(["demo"])
    end

    it "understands and deprecates :autotagger_stages" do
      expect(AutoTagger::Deprecator).to receive(:warn)
      helper = AutoTagger::CapistranoHelper.new :autotagger_stages => ["demo"]
      expect(helper.stages).to eq(["demo"])
    end

    it "makes all stages strings" do
      helper = AutoTagger::CapistranoHelper.new :auto_tagger_stages => [:demo]
      expect(helper.stages).to eq(["demo"])
    end
  end

end
