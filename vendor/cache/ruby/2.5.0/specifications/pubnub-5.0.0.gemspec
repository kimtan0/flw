# -*- encoding: utf-8 -*-
# stub: pubnub 5.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "pubnub".freeze
  s.version = "5.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["PubNub".freeze]
  s.date = "2022-01-13"
  s.description = "Ruby anywhere in the world in 250ms with PubNub!".freeze
  s.email = ["support@pubnub.com".freeze]
  s.homepage = "http://github.com/pubnub/ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4".freeze)
  s.rubygems_version = "3.3.17".freeze
  s.summary = "PubNub Official Ruby gem.".freeze

  s.installed_by_version = "3.3.17" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<addressable>.freeze, [">= 2.0.0"])
    s.add_runtime_dependency(%q<concurrent-ruby>.freeze, ["~> 1.1.5"])
    s.add_runtime_dependency(%q<concurrent-ruby-edge>.freeze, ["~> 0.5.0"])
    s.add_runtime_dependency(%q<dry-validation>.freeze, ["~> 1.0"])
    s.add_runtime_dependency(%q<httpclient>.freeze, ["~> 2.8", ">= 2.8.3"])
    s.add_runtime_dependency(%q<json>.freeze, [">= 2.2.0", "< 3"])
    s.add_runtime_dependency(%q<timers>.freeze, [">= 4.3.0"])
  else
    s.add_dependency(%q<addressable>.freeze, [">= 2.0.0"])
    s.add_dependency(%q<concurrent-ruby>.freeze, ["~> 1.1.5"])
    s.add_dependency(%q<concurrent-ruby-edge>.freeze, ["~> 0.5.0"])
    s.add_dependency(%q<dry-validation>.freeze, ["~> 1.0"])
    s.add_dependency(%q<httpclient>.freeze, ["~> 2.8", ">= 2.8.3"])
    s.add_dependency(%q<json>.freeze, [">= 2.2.0", "< 3"])
    s.add_dependency(%q<timers>.freeze, [">= 4.3.0"])
  end
end
