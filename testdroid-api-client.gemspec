Gem::Specification.new do |s|
  s.name               = "testdroid-api-client"
  s.version            = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sakari Rautiainen", "Marek Sierociński"]
  s.date = %q{2014-12-19}
  s.description = %q{Ruby client for testdroid api v2}
  s.license       = "MIT"
  s.email = %q{sakari.rautiainen@bitbar.com}
  s.files         = `git ls-files`.split($/)
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage = %q{http://rubygems.org/gems/testdroid-api-client}
  s.require_paths = ['lib']
  s.rubygems_version = %q{2.2.2}
  s.summary = %q{Testdroid API Client!}
  s.add_runtime_dependency "rest-client",'~> 2.0', '>= 2.0.0'
  s.add_runtime_dependency "deep_merge",'~> 1.1', '>= 1.1.1'
  s.add_development_dependency "bump",'~> 0.5'
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-collection_matchers"
  s.add_development_dependency "vcr",  '~> 2.9'
  s.add_development_dependency "webmock", '~> 1.9'
  s.add_development_dependency "yard", '~> 0.8'

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
