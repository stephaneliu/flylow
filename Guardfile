
guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)/assets/\w+/(.+\.(css|js|html)).*})  { |m| "/assets/#{m[2]}" }
end

guard 'ctags-bundler', src_path: ["app", "lib", "spec/support"] do
  watch(/^(app|lib|spec\/support)\/.*\.rb$/)
  watch('Gemfile.lock')
end

# Runs rake db:test:clone on schema.rb change
#guard 'schema' do
#  watch('db/schema.rb')
#end

# :cucumber => false
# :rspec => false
# :test_unit => false
# :bundler => false                          # Don't use "bundle exec"
# :test_unit_port => 1233                    # Default: 8988
# :rspec_port => 1234                        # Default: 8989
# :cucumber_port => 4321                     # Default: 8990
# :test_unit_env => { 'RAILS_ENV' => 'baz' } # Default: nil
# :rspec_env => { 'RAILS_ENV' => 'foo' }     # Default: nil
# :cucumber_env => { 'RAILS_ENV' => 'bar' }  # Default: nil

guard 'spork', :cucumber => false, :rspec_env => { 'RAILS_ENV' => 'test' }, :wait => 45 do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch(%r{spec/support/.+\.rb$})
  watch(%r{spec/support/matchers/.+\.rb$})
  watch(%r{spec/support/helpers/.+\.rb$})
  watch(%r{spec/factories/*})
end

# Run all spec by hitting return key in guard console
# Guard rspec
# version: 1               # force use RSpec version 1, default: 2
# cli: "-c -f doc"         # pass arbitrary RSpec CLI arguments, default: "-f progress"
# bundler: false           # don't use "bundle exec" to run the RSpec command, default: true
# rvm: ['1.8.7', '1.9.2']  # directly run your specs on multiple Rubies, default: nil
# notification: false      # don't display Growl (or Libnotify) notification after the specs are done running, default: true
# all_after_pass: false    # don't run all specs after changed specs pass, default: true
# all_on_start: false      # don't run all the specs at startup, default: true
# keep_failed: false       # keep failed specs until them pass, default: true
guard 'rspec', cli: '--drb --fail-fast' , keep_failed: true, all_on_start: true, all_after_pass: true do
# guard 'rspec', cli: '--drb' , keep_failed: true, all_on_start: true, all_after_pass: true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  # Capybara request specs
  # watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", 
                                                             "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", 
                                                             "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/models/ability.rb')                      { "spec/controllers" }
end
