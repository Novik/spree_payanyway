# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_payanyway'
  s.version     = '3.0.1'
  s.summary     = 'Adds payment method for PayAnyWay'
  # s.description = 'TODO: Add (optional) gem description here'
  s.required_ruby_version = '>= 2.0.0'

  s.authors       = ["Novik"]
  s.email         = ["novik65@gmail.com"]
  s.homepage  = 'https://github.com/Novik/spree_payanyway'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = [ 'lib' ]
  s.requirements << 'none'  

  s.add_dependency 'spree_core', '~> 3.0.1'
end
