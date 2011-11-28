# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fleuve/version"

Gem::Specification.new do |s|
  s.name        = "fleuve"
  s.version     = Fleuve::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Keith Bennett"]
  s.email       = ["keithrbennett@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Solves the LeanDog "Path of Least Resistance" problem.}
  s.description = %q{}

  s.rubyforge_project = "fleuve"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
