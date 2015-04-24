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

group :red_green_refactor, halt_on_fail: true do
  # failed_mode:
  #   - :focus (default) - Focus on the first 10 failed specs, rerun it until they pass
  #   - :keep - keep failed specs until they pass (add new failing specs when discovered)
  #   - :none - just report
  # -f (format):
  #   - doc
  #   - progress
  guard :rspec, cmd: 'bin/rspec -f progress', failed_mode: :keep, all_on_start: true, all_after_pass: true do
    watch('config/routes.rb')                           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml|builder)$})         { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", 
                                                               "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", 
                                                               "spec/acceptance/#{m[1]}_spec.rb"] }
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
    watch('app/models/ability.rb')                      { "spec/controllers" }
    watch('config/routes.rb')                           { "spec/routing" }
    watch('tmp/test_models')                            { "spec/models" }
  end

  guard :rubocop, all_on_start: false, cli: ['--rails', '--display-cop-names'] do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
