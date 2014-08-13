require 'spec_helper'
require 'capistrano'

describe "AutoTagger Capistrano recipes" do

  describe "create_ref" do
    before do
      @auto_tagger = double(AutoTagger::Base)
      expect(AutoTagger::Base).to receive(:new).and_return(@auto_tagger)
      
      @config = Capistrano::Configuration.instance = Capistrano::Configuration.new
      @config.load "lib/auto_tagger/recipes"
      allow(@config).to receive(:real_revision).and_return("REAL_REVISION")

      @ref = double(:name => "TAG", :sha => "SHA")
    end
    
    it "creates a tag from the real_revision when :auto_tagger_stage is set" do
      expect(@auto_tagger).to receive(:create_ref).with("REAL_REVISION").and_return(@ref)
      @config.set :auto_tagger_stage, :ci
      @config.auto_tagger.create_ref
    end
    
    it "creates a tag from the real_revision when :stage is set" do
      expect(@auto_tagger).to receive(:create_ref).with("REAL_REVISION").and_return(@ref)
      @config.set :stage, :ci
      @config.auto_tagger.create_ref
    end
    
    it "creates a tag from HEAD when neither :auto_tagger_stage nor :stage are set" do
      expect(@auto_tagger).to receive(:create_ref).with(no_args).and_return(@ref)
      @config.auto_tagger.create_ref
    end
  end
  
end
