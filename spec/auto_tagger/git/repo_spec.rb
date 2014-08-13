require 'spec_helper'

describe AutoTagger::Git::Repo do

  before do
    allow(File).to receive(:exists?).and_return(true)
    @commander = double(AutoTagger::Commander)
  end

  describe "#path" do
    it "raises an error if the path is blank" do
      expect do
        AutoTagger::Git::Repo.new(" ").path
      end.to raise_error(AutoTagger::Git::Repo::NoPathProvidedError)

      expect do
        AutoTagger::Git::Repo.new(nil).path
      end.to raise_error(AutoTagger::Git::Repo::NoPathProvidedError)
    end

    it "raises and error if the path does not exist" do
      expect(File).to receive(:exists?).with("/foo").and_return(false)
      expect do
        AutoTagger::Git::Repo.new("/foo").path
      end.to raise_error(AutoTagger::Git::Repo::NoSuchPathError)
    end

    it "raises and error if the path does not have a .git directory" do
      expect(File).to receive(:exists?).with("/foo").and_return(true)
      expect(File).to receive(:exists?).with("/foo/.git").and_return(false)
      expect do
        AutoTagger::Git::Repo.new("/foo").path
      end.to raise_error(AutoTagger::Git::Repo::InvalidGitRepositoryError)
    end

    it "returns the path if it's a git directory" do
      expect(File).to receive(:exists?).with("/foo").and_return(true)
      expect(File).to receive(:exists?).with("/foo/.git").and_return(true)
      expect(AutoTagger::Git::Repo.new("/foo").path).to eq("/foo")
    end
  end

  describe "#refs" do
    it "returns a new refset" do
      expect(AutoTagger::Git::Repo.new("/foo").refs).to be_kind_of(AutoTagger::Git::RefSet)
    end
  end

  describe "#==" do
    it "returns true if the path matches" do
      expect(AutoTagger::Git::Repo.new("/foo")).to eq(AutoTagger::Git::Repo.new("/foo"))
    end

    it "returns false if the path does not match" do
      expect(AutoTagger::Git::Repo.new("/foo")).not_to eq(AutoTagger::Git::Repo.new("/bar"))
    end
  end

  describe "#latest_commit_sha" do
    it "returns the latest sha from HEAD" do
      repo = AutoTagger::Git::Repo.new("/foo")
      expect(repo).to receive(:read).with("rev-parse HEAD").and_return(" abc123 ")
      expect(repo.latest_commit_sha).to eq("abc123")
    end
  end

  describe "#read" do
    it "formats the command and sends it to the system" do
      repo = AutoTagger::Git::Repo.new("/foo")
      allow(repo).to receive(:commander).and_return(@commander)
      expect(@commander).to receive(:read).with("git rev-parse HEAD").and_return("lkj")
      expect(repo.read("rev-parse HEAD")).to eq("lkj")
    end

    it "respects the passed in executable" do
      repo = AutoTagger::Git::Repo.new("/foo", :executable => "/usr/bin/git")
      allow(repo).to receive(:commander).and_return(@commander)
      expect(@commander).to receive(:read).with("/usr/bin/git rev-parse HEAD").and_return("lkj")
      expect(repo.read("rev-parse HEAD")).to eq("lkj")
    end
  end

  describe "#exec" do
    it "sends the exec command to the commander" do
      repo = AutoTagger::Git::Repo.new("/foo")
      allow(repo).to receive(:commander).and_return(@commander)
      expect(@commander).to receive(:execute).with("git push origin master").and_return(true)
      repo.exec("push origin master")
    end

    it "raises an error if the command returns false" do
      repo = AutoTagger::Git::Repo.new("/foo")
      allow(repo).to receive(:commander).and_return(@commander)
      expect(@commander).to receive(:execute).with("git push origin master").and_return(false)
      expect do
        repo.exec("push origin master")
      end.to raise_error(AutoTagger::Git::Repo::GitCommandFailedError)
    end

    it "sends the print command to the commander if execute_commands is false" do
      repo = AutoTagger::Git::Repo.new("/foo", :execute_commands => false)
      allow(repo).to receive(:commander).and_return(@commander)
      expect(@commander).to receive(:print).with("git push origin master")
      repo.exec("push origin master")
    end
  end

end
