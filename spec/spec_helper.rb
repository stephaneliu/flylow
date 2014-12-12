ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rubygems'
require 'rspec/rails'
require 'email_spec'
#require 'capybara/poltergeist'

FactoryGirl.definition_file_paths = [File.join(Rails.root, 'spec', 'factories')]

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  config.mock_with :rspec
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.include FactoryGirl::Syntax::Methods
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  
  config.use_transactional_fixtures = true
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
