source 'https://rubygems.org'

gem 'rails', '4.2.1'

gem 'bootstrap-sass', '~>3.3.1.0'
gem 'autoprefixer-rails', '~>4.0.2'
gem 'descriptive-statistics', '~>2.1.2'
gem 'cancan', '1.6.10'
gem 'chartkick', '~>1.3.2'
gem 'coveralls', require: false
gem 'descriptive_statistics', '~>2.4.0'
gem 'groupdate', '~>2.3.0'
gem 'devise', '3.4.1'
gem 'figaro', '0.7.0'
gem 'haml-rails', '0.6.0'
gem 'mechanize', '~>2.6.0'   # pin to 2.6 due to mime-type conflict with rails 4.1.1
gem 'rolify', '3.4.0'
gem 'simple_form', '3.0.2'
gem 'gon', '5.2.3'
gem 'high_voltage', '2.1.0'
gem 'jquery-rails', '3.1.2'
gem 'mysql2'
gem 'pg'
gem 'sass-rails',   '4.0.3'
gem 'whenever', require: false

group :assets do
  gem 'coffee-rails', '4.1.0' 
  gem 'uglifier', '>=2.6.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'annotate'
  gem 'foreman'
  gem 'fuubar'
  gem 'guard'
  gem 'guard-ctags-bundler'
  gem 'guard-livereload', require: false
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'guard-schema'
  gem 'mina'
  gem 'rack-livereload' 
  gem 'rb-fsevent'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'sqlite3'
  gem 'thin'
  gem 'tracer_bullets'
  gem 'web-console'

  # ~/.irbrc files
  gem 'awesome_print'
  gem 'bullet'
  gem 'hirb'
  gem 'looksee'
  gem 'what_methods'
  gem 'wirble'
end

group :test do
  gem 'rake' # required by Travis CI
  gem 'capybara'
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
  gem 'newrelic_rpm'
end
