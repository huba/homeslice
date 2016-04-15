# coding: utf-8

Gem::Specification.new do |s|
  s.name = 'homeslice'
  s.version = '0.0.1'
  s.licenses = ['MIT']
  s.summary = 'A new experimental slicer engine for 3D printing.'
  s.authors = ['Huba Nagy']
  s.email = '12huba@gmail.com'
  s.homepage = 'https://github.com/huba/homeslice'
  
  s.files = `git ls-files -z`.split("\x0")
  s.test_files = s.files.grep(%r{^spec/})
  s.require_paths = 'lib'
  
  s.add_runtime_dependency 'geometry'
  
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
end