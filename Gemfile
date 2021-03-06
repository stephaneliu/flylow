source 'https://rubygems.org'

gem 'rails', '4.2.5'

gem 'autoprefixer-rails', '~>6.1'
gem 'awesome_print'
gem 'bootstrap-sass', '~>3.3.4'
gem 'cancan', '1.6.10'
gem 'chartkick', '~>1.3'
gem 'descriptive_statistics', '~>2.5'
gem 'devise', '~>3.5'
gem 'figaro', '~>1.1'
gem 'groupdate', '~>2.4'
gem 'haml-rails', '0.9.0'
gem 'high_voltage', '~>2.3'
gem 'jquery-rails', '~>4.0.5'
gem 'js-routes', '~>1.0'
gem 'mechanize', '2.7.3'   # pin to 2.6 due to mime-type conflict with rails 4.1.1
# mysql2 must be before rack-mini-profiler
gem 'mysql2'
gem 'rolify', '4.0.0'
gem 'sass-rails',   '~>5.0.4'
gem 'whenever', require: false

group :assets do
  gem 'coffee-rails', '4.1.0' 
  gem 'uglifier', '>=2.6.0'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'fuubar'
  gem 'guard'
  gem 'guard-ctags-bundler'
  gem 'guard-livereload', require: false
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'html2haml'
  gem 'lol_dba'
  gem 'quiet_assets'
  gem 'rack-livereload' 
  gem 'rb-fsevent'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'sqlite3'
  gem 'thin'
  gem 'tracer_bullets'
  gem 'web-console'
  gem 'rubycritic', require: false

  # ~/.irbrc files
  gem 'bullet'
  gem 'hirb'
  gem 'looksee'
  gem 'what_methods'
  gem 'wirble'
  # rack-mini-profiler must be after mysql2
  gem 'rack-mini-profiler'
  gem 'flamegraph'
end

group :test do
  gem 'rake' # required by Travis CI
  gem 'capybara'
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'launchy'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
end

group :production do 
  gem 'unicorn'
end

