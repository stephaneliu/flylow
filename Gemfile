source 'https://rubygems.org'

gem 'rails', '3.2.12'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3'
end

gem "thin", "~>1.5.0"
gem "pg", "~>0.14.1"
gem 'jquery-rails'
gem "haml-rails", ">= 0.4"
gem "bootstrap-sass", ">= 2.3.0.0"
gem "devise", ">= 2.2.3"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "figaro", ">= 0.5.3"
gem "mechanize", "~>2.5.1"

group :development do
  gem "quiet_assets", ">= 1.0.1"
  gem "better_errors", ">= 0.6.0"
  gem "binding_of_caller", ">= 0.6.9"
  gem "debugger"
  gem "html2haml", ">= 1.0.0"
  gem 'sqlite3'
  gem 'annotate'
  gem 'travis-lint'
end

group :test do
  gem "database_cleaner", ">= 0.9.1"
  gem "email_spec", ">= 1.4.0"
  gem "cucumber-rails", ">= 1.3.0", :require => false
  gem "launchy", ">= 2.2.0"
  gem "capybara", ">= 2.0.2"
end

group :development, :test do
  gem "rspec-rails", ">= 2.12.2"
  gem "factory_girl_rails", ">= 4.2.0"
end

group :production do
  gem 'newrelic_rpm'
end
