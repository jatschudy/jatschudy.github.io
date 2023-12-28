# -*- encoding: utf-8 -*-
# stub: jekyll-theme-chirpy 6.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-theme-chirpy".freeze
  s.version = "6.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/cotes2020/jekyll-theme-chirpy/issues", "documentation_uri" => "https://github.com/cotes2020/jekyll-theme-chirpy/#readme", "homepage_uri" => "https://cotes2020.github.io/chirpy-demo", "plugin_type" => "theme", "source_code_uri" => "https://github.com/cotes2020/jekyll-theme-chirpy", "wiki_uri" => "https://github.com/cotes2020/jekyll-theme-chirpy/wiki" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Cotes Chung".freeze]
  s.date = "2023-11-12"
  s.email = ["cotes.chung@gmail.com".freeze]
  s.homepage = "https://github.com/cotes2020/jekyll-theme-chirpy".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0".freeze)
  s.rubygems_version = "3.3.15".freeze
  s.summary = "A minimal, responsive, and feature-rich Jekyll theme for technical writing.".freeze

  s.installed_by_version = "3.3.15" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<jekyll>.freeze, ["~> 4.3"])
    s.add_runtime_dependency(%q<jekyll-paginate>.freeze, ["~> 1.1"])
    s.add_runtime_dependency(%q<jekyll-redirect-from>.freeze, ["~> 0.16"])
    s.add_runtime_dependency(%q<jekyll-seo-tag>.freeze, ["~> 2.8"])
    s.add_runtime_dependency(%q<jekyll-archives>.freeze, ["~> 2.2"])
    s.add_runtime_dependency(%q<jekyll-sitemap>.freeze, ["~> 1.4"])
    s.add_runtime_dependency(%q<jekyll-include-cache>.freeze, ["~> 0.2"])
  else
    s.add_dependency(%q<jekyll>.freeze, ["~> 4.3"])
    s.add_dependency(%q<jekyll-paginate>.freeze, ["~> 1.1"])
    s.add_dependency(%q<jekyll-redirect-from>.freeze, ["~> 0.16"])
    s.add_dependency(%q<jekyll-seo-tag>.freeze, ["~> 2.8"])
    s.add_dependency(%q<jekyll-archives>.freeze, ["~> 2.2"])
    s.add_dependency(%q<jekyll-sitemap>.freeze, ["~> 1.4"])
    s.add_dependency(%q<jekyll-include-cache>.freeze, ["~> 0.2"])
  end
end
