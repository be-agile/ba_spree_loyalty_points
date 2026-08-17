# encoding: UTF-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree_loyalty_points/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'ba_spree_loyalty_points'
  s.version     = SpreeLoyaltyPoints::VERSION
  s.summary     = 'Add loyalty points to spree (be agile fork)'
  s.description = 'To award loyalty points and add loyalty points payment method to spree.  Compatible with Ruby 3.1, Rails 7.1 and Spree 4.10.'
  s.required_ruby_version = '>= 3.1.4'
  s.files = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*']

  s.author      = 'be agile Co., Ltd.'
  s.email       = 'develop@be-agile.jp'
  s.homepage    = 'https://github.com/be-agile/ba_spree_loyalty_points'
  s.licenses    = ['AGPL-3.0-or-later']

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 5.3.0'
  s.add_dependency 'spree_admin', '= 5.3.6'
  s.add_dependency 'spree_storefront', '= 5.3.6'
  s.add_dependency 'deface'
  s.add_development_dependency 'capybara', '~> 2.5'
  s.add_development_dependency 'coffee-rails', '~> 4.2.1'
  s.add_development_dependency 'database_cleaner', '~> 1.5.3'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker', '~> 2.2.0'
  s.add_development_dependency 'rspec-rails', '~> 3.4'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1.1'
  s.add_development_dependency 'sass-rails', '~> 5.1.1'
  s.add_development_dependency 'selenium-webdriver', '~> 3.0.8'
  s.add_development_dependency 'simplecov', '~> 0.13.0'
  s.add_development_dependency 'sqlite3', '~> 1.3.13'
  s.add_development_dependency 'rails-controller-testing', '~> 1.0.1'

  # @gem-override マーカーの差分確認に使う開発ツール
  s.add_development_dependency 'gem_override_marker'
end
