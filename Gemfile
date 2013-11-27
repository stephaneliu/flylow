source 'https://rubygems.org'

def os_platform_only(require_as, os=:darwin)
  RUBY_PLATFORM.include?(os.to_s) && require_as
end

gem 'rails', '3.2.13'
gem "haml-rails", ">= 0.4"
gem 'jquery-rails'
gem 'capistrano'
gem 'unicorn'
gem "bootstrap-sass", ">= 2.3.0.0"

gem "devise", ">= 2.2.3"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "figaro", ">= 0.5.3"
gem "mechanize", "~>2.5.1"
gem 'high_voltage', '~>1.2.2'
gem 'foreman', '~>0.62.0'
gem 'gon'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3'
end

group :development do
  gem "quiet_assets", ">= 1.0.1"
  gem "better_errors", ">= 0.6.0"
  gem "binding_of_caller", ">= 0.6.9"
  #gem "debugger"
  gem "html2haml", ">= 1.0.0"
  gem 'sqlite3'
  gem 'annotate'
  gem 'travis-lint'
  gem 'spork'
  gem 'guard-livereload'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-ctags-bundler'
  gem 'guard-schema'
  gem 'rb-fsevent', '~>0.9'
  gem 'terminal-notifier-guard', require: os_platform_only('terminal-notifier-guard') # notify to darwin notification
  gem 'rb-inotify', require: os_platform_only('rb-inotify', :linux)
  # ~/.irbrc files
  gem 'bullet'
  gem 'awesome_print'
  gem 'wirble'
  gem 'what_methods'
  gem 'hirb'
  gem 'looksee'
end

group :test do
  gem "database_cleaner", ">= 0.9.1"
  gem "email_spec", ">= 1.4.0"
  gem 'shoulda-matchers'
  gem "cucumber-rails", ">= 1.3.0", :require => false
  gem "launchy", ">= 2.2.0"
  gem "capybara", ">= 2.0.2"
  gem 'rspec-instafail'
  gem "rspec-rails", ">= 2.12.2"
  gem "rspec-fire"
  gem 'timecop', "~>0.5.9"
end

group :development, :test do
  gem "factory_girl_rails", ">= 4.2.0"
end

group :production do
  #gem 'newrelic_rpm'
  gem "pg", "~>0.14.1"
  #gem 'memcachier', '~>0.0.2' # passes heroku ENV vars to dalli config
  gem 'dalli', '~>2.6.2'
end
