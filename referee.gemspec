# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'referee/version'

Gem::Specification.new do |s|
  s.name        = 'fix-engine'
  s.version     = Referee::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['David François']
  s.email       = ['david.francois@paymium.com']
  s.homepage    = 'https://github.com/davout/referee'
  s.summary     = 'The guy does arbitrage'
  s.description = s.summary

  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'

  s.add_dependency 'fix-protocol'
  s.add_dependency 'eventmachine'
  s.add_dependency 'eventmachine'
  s.add_dependency 'websocket-native'
  s.add_dependency 'pusher-client'
  s.add_dependency 'eventmachine'
  s.add_dependency 'fix-engine'
  s.add_dependency 'oj'

  s.files         = Dir.glob('{lib,bin}/**/*') + %w(LICENSE README.md)
  s.require_path  = 'lib'
  s.bindir        = 'bin'
end
