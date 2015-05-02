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
  guard :rspec, cmd: 'bin/rspec -f Fuubar --color spec', failed_mode: :focus, all_on_start: true, all_after_pass: true do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w(erb haml slim))
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) do |m|
      [
        rspec.spec.("routing/#{m[1]}_routing"),
        rspec.spec.("controllers/#{m[1]}_controller"),
        rspec.spec.("acceptance/#{m[1]}")
      ]
    end

    # Rails config changes
    watch(rails.spec_helper)     { rspec.spec_dir }
    watch(rails.routes)          { "#{rspec.spec_dir}/routing" }
    watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

    # Capybara features specs
    watch(rails.view_dirs)     { |m| rspec.spec.("features/#{m[1]}") }

    # Turnip features and steps
    watch(%r{^spec/acceptance/(.+)\.feature$})
    watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
      Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
    end
  end

  guard :rubocop, all_on_start: true, cli: ['--rails', '--display-cop-names'] do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end

