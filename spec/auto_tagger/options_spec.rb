require 'spec_helper'

describe AutoTagger::Options do

  shared_examples_for "common options" do
    it "understands --date-separator" do
      options = AutoTagger::Options.from_command_line ["--date-separator=-"]
      expect(options[:date_separator]).to eq("-")
    end

    it "understands --remote" do
      options = AutoTagger::Options.from_command_line ["--remote=origin"]
      expect(options[:remote]).to eq("origin")
    end

    it "understands --ref-path" do
      options = AutoTagger::Options.from_command_line ["--ref-path=tags"]
      expect(options[:ref_path]).to eq("tags")
    end

    it "understands --stages" do
      options = AutoTagger::Options.from_command_line ["--stages=foo,bar,baz"]
      expect(options[:stages]).to eq("foo,bar,baz")
    end

    it "understands --refs-to-keep" do
      options = AutoTagger::Options.from_command_line ["--refs-to-keep=4"]
      expect(options[:refs_to_keep]).to eq(4)
    end

    it "understands --dry-run" do
      options = AutoTagger::Options.from_command_line ["--dry-run"]
      expect(options[:dry_run]).to eq(true)

      options = AutoTagger::Options.from_command_line ["--dry-run=true"]
      expect(options[:dry_run]).to eq(true)

      options = AutoTagger::Options.from_command_line ["--dry-run=false"]
      expect(options[:dry_run]).to eq(false)
    end

    it "understands --fetch-refs" do
      options = AutoTagger::Options.from_command_line ["--fetch-refs=true"]
      expect(options[:fetch_refs]).to eq(true)

      options = AutoTagger::Options.from_command_line ["--fetch-refs=false"]
      expect(options[:fetch_refs]).to eq(false)
    end

    it "understands --push-refs" do
      options = AutoTagger::Options.from_command_line ["--push-refs=true"]
      expect(options[:push_refs]).to eq(true)

      options = AutoTagger::Options.from_command_line ["--push-refs=false"]
      expect(options[:push_refs]).to eq(false)
    end

    it "understands --offline" do
      options = AutoTagger::Options.from_command_line ["--offline"]
      expect(options[:offline]).to be_nil

      options = AutoTagger::Options.from_command_line ["--offline=true"]
      expect(options[:offline]).to eq(true)
    end
  end

  describe "#from_command_line" do

    it_should_behave_like "common options"

    it "takes the first argument to be the stage" do
      options = AutoTagger::Options.from_command_line ["ci"]
      expect(options[:stage]).to eq("ci")
    end

    it "takes the second argument to be the path" do
      options = AutoTagger::Options.from_command_line ["ci", "../"]
      expect(options[:path]).to eq("../")
    end

    it "understands --opts-file" do
      options = AutoTagger::Options.from_command_line ["--opts-file=foo"]
      expect(options[:opts_file]).to eq("foo")
    end

    it "understands all help options" do
      options = AutoTagger::Options.from_command_line ["ci"]
      expect(options[:show_help]).to be_nil

      options = AutoTagger::Options.from_command_line ["help"]
      expect(options[:show_help]).to eq(true)

      options = AutoTagger::Options.from_command_line ["-h"]
      expect(options[:show_help]).to eq(true)

      options = AutoTagger::Options.from_command_line ["--help"]
      expect(options[:show_help]).to eq(true)

      options = AutoTagger::Options.from_command_line ["-?"]
      expect(options[:show_help]).to eq(true)

      options = AutoTagger::Options.from_command_line []
      expect(options[:show_help]).to eq(true)
    end

    it "understands --version" do
      options = AutoTagger::Options.from_command_line ["ci"]
      expect(options[:show_version]).to be_nil

      options = AutoTagger::Options.from_command_line ["version"]
      expect(options[:show_version]).to eq(true)

      options = AutoTagger::Options.from_command_line ["--version"]
      expect(options[:show_version]).to eq(true)

      options = AutoTagger::Options.from_command_line ["-v"]
      expect(options[:show_version]).to eq(true)
    end

    it "chooses the right command" do
      options = AutoTagger::Options.from_command_line ["config"]
      expect(options[:command]).to eq(:config)

      options = AutoTagger::Options.from_command_line ["version"]
      expect(options[:command]).to eq(:version)

      options = AutoTagger::Options.from_command_line ["-v"]
      expect(options[:command]).to eq(:version)

      options = AutoTagger::Options.from_command_line ["help"]
      expect(options[:command]).to eq(:help)

      options = AutoTagger::Options.from_command_line [""]
      expect(options[:command]).to eq(:help)

      options = AutoTagger::Options.from_command_line ["cleanup"]
      expect(options[:command]).to eq(:cleanup)

      options = AutoTagger::Options.from_command_line ["list"]
      expect(options[:command]).to eq(:list)

      options = AutoTagger::Options.from_command_line ["create"]
      expect(options[:command]).to eq(:create)

      options = AutoTagger::Options.from_command_line ["ci"]
      expect(options[:command]).to eq(:create)

      options = AutoTagger::Options.from_command_line ["delete_locally"]
      expect(options[:command]).to eq(:delete_locally)

      options = AutoTagger::Options.from_command_line ["delete_on_remote"]
      expect(options[:command]).to eq(:delete_on_remote)
    end
  end

  describe "#from_file" do
    it_should_behave_like "common options"
  end

end
