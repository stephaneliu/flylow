source 'https://rubygems.org'

gem 'rails', '4.1.1'

gem "bootstrap-sass", "3.1.1.1"
gem "cancan", "1.6.10"
gem "devise", "3.2.0"
gem "figaro", "0.7.0"
gem "haml-rails", "0.5.3"
gem "mechanize", "~>2.6.0"   # pin to 2.6 due to mime-type conflict with rails 4.1.1
gem "rolify", "3.4.0"
gem "simple_form", "3.0.2"
gem 'gon', '5.0.4'
gem 'high_voltage', '2.1.0'
gem 'jquery-rails', '3.1.0'
gem 'mysql2'

# TODO upgrade

group :assets do
  gem 'sass-rails',   '4.0.3'
  gem 'coffee-rails', '4.0.1' 
  gem 'uglifier', '>= 1.3.0'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "html2haml"
  gem "quiet_assets"
  gem 'annotate'
  gem 'foreman'
  gem 'guard-ctags-bundler'
  gem 'guard-livereload', require: false
  gem 'guard-rspec'
  gem 'guard-schema'
  gem 'guard-spork'
  gem 'mina'
  gem 'rack-livereload' 
  gem 'rb-fsevent'
  gem 'spring'
  gem 'sqlite3'
  gem 'terminal-notifier-guard' if `uname` =~ /Darwin/
  gem 'thin'

  # ~/.irbrc files
  gem 'awesome_print'
  gem 'bullet'
  gem 'hirb'
  gem 'looksee'
  gem 'what_methods'
  gem 'wirble'
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "email_spec"
  gem "launchy"
  gem "rspec-rails"
  gem 'shoulda-matchers'
  gem 'timecop'
end

group :development, :test do
  gem "factory_girl_rails"
end

group :production do 
  gem 'unicorn'
end
