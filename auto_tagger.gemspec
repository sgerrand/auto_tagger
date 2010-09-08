# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{auto_tagger}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Dean", "Brian Takita", "Mike Grafton", "Bruce Krysiak", "Pat Nakajima", "Jay Zeschin", "Mike Barinek", "Sarah Mei"]
  s.date = %q{2010-09-10}
  s.default_executable = %q{autotag}
  s.email = %q{jeff@zilkey.com}
  s.executables = ["autotag"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "CHANGELOG",
     "Gemfile",
     "Gemfile.lock",
     "MIT-LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "auto_tagger.gemspec",
     "bin/autotag",
     "features/autotag.feature",
     "features/deployment.feature",
     "features/step_definitions/autotag_steps.rb",
     "features/step_definitions/deployment_steps.rb",
     "features/support/env.rb",
     "features/support/step_helpers.rb",
     "features/templates/cap_ext_deploy.erb",
     "features/templates/deploy.erb",
     "features/templates/stage.erb",
     "lib/auto_tagger.rb",
     "lib/auto_tagger/base.rb",
     "lib/auto_tagger/capistrano_helper.rb",
     "lib/auto_tagger/command_line.rb",
     "lib/auto_tagger/commander.rb",
     "lib/auto_tagger/configuration.rb",
     "lib/auto_tagger/deprecator.rb",
     "lib/auto_tagger/git/ref.rb",
     "lib/auto_tagger/git/ref_set.rb",
     "lib/auto_tagger/git/repo.rb",
     "lib/auto_tagger/options.rb",
     "lib/auto_tagger/recipes.rb",
     "spec/auto_tagger/base_spec.rb",
     "spec/auto_tagger/capistrano_helper_spec.rb",
     "spec/auto_tagger/command_line_spec.rb",
     "spec/auto_tagger/commander_spec.rb",
     "spec/auto_tagger/configuration_spec.rb",
     "spec/auto_tagger/git/ref_set_spec.rb",
     "spec/auto_tagger/git/ref_spec.rb",
     "spec/auto_tagger/git/repo_spec.rb",
     "spec/auto_tagger/options_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/zilkey/auto_tagger}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Helps you automatically create tags for each stage in a multi-stage deploment and deploy from the latest tag from the previous environment}
  s.test_files = [
    "spec/auto_tagger/base_spec.rb",
     "spec/auto_tagger/capistrano_helper_spec.rb",
     "spec/auto_tagger/command_line_spec.rb",
     "spec/auto_tagger/commander_spec.rb",
     "spec/auto_tagger/configuration_spec.rb",
     "spec/auto_tagger/git/ref_set_spec.rb",
     "spec/auto_tagger/git/ref_spec.rb",
     "spec/auto_tagger/git/repo_spec.rb",
     "spec/auto_tagger/options_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 2.5.3"])
    else
      s.add_dependency(%q<capistrano>, [">= 2.5.3"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 2.5.3"])
  end
end

