require 'spec_helper'

describe AutoTagger::Git::RefSet do

  before do
    @repo = double(AutoTagger::Git::Repo, :exec => true)
    @ref_set = AutoTagger::Git::RefSet.new(@repo)
    @refstring = <<-LIST
      23087241c495773c8eece1c195cc453a8055c4eb refs/tags/200808080808
      23087241c495773b8eecr1c195cd453a8056c4eb refs/tags/200808080809
    LIST
  end

  describe "#all" do
    it "returns an array of refs" do
      expect(@repo).to receive(:read).with("show-ref").and_return(@refstring)
      refs = @ref_set.all
      expect(refs.length).to eq(2)
      expect(refs.first.name).to eq("refs/tags/200808080808")
      expect(refs.first.sha).to eq("23087241c495773c8eece1c195cc453a8055c4eb")
    end
  end

  describe "#find_by_sha" do
    it "returns a ref by the sha" do
      expect(@repo).to receive(:read).with("show-ref").and_return(@refstring)
      ref = @ref_set.find_by_sha("23087241c495773b8eecr1c195cd453a8056c4eb")
      expect(ref.name).to eq("refs/tags/200808080809")
    end

    it "returns nil if it's not found" do
      expect(@repo).to receive(:read).with("show-ref").and_return(@refstring)
      expect(@ref_set.find_by_sha("abc123")).to be_nil
    end
  end

  describe "#create" do
    it "instantiates and saves a ref" do
      expect(@repo).to receive(:exec).with("update-ref refs/auto_tags/demo/2008 abc123")
      @ref_set.create "abc123", "refs/auto_tags/demo/2008"
    end

    it "returns the ref" do
      ref = @ref_set.create("abc123", "refs/auto_tags/demo/2008")
      expect(ref.sha).to eq("abc123")
      expect(ref.name).to eq("refs/auto_tags/demo/2008")
    end
  end

  describe "#push" do
    it "pushes all refs to the specified remote" do
      expect(@repo).to receive(:exec).with("push myremote refs/auto_tags/*:refs/auto_tags/*")
      @ref_set.push "refs/auto_tags/*", "myremote"
    end

    it "defaults to origin" do
      expect(@repo).to receive(:exec).with("push origin refs/auto_tags/*:refs/auto_tags/*")
      @ref_set.push "refs/auto_tags/*"
    end
  end

  describe "#fetch" do
    it "fetches all refs to the specified remote" do
      expect(@repo).to receive(:exec).with("fetch myremote refs/auto_tags/*:refs/auto_tags/*")
      @ref_set.fetch "refs/auto_tags/*", "myremote"
    end

    it "defaults to origin" do
      expect(@repo).to receive(:exec).with("fetch origin refs/auto_tags/*:refs/auto_tags/*")
      @ref_set.fetch "refs/auto_tags/*"
    end
  end

end
