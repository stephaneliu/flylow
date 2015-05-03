require 'vcr'

real_requests = true # ENV['REAL_REQUESTS']

RSpec.configure do |config|
  if real_requests
    config.before(:each) do
      VCR.eject_cassette
    end
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/support/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true if real_requests
  c.default_cassette_options = { record: :new_episodes }
end
