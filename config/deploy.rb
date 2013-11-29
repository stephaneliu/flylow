set :application,     'flylow'
set :repo_url,        'git@github.com:stephaneliu/hal_fare.git'
set :rvm_ruby_string, "ruby-2.0.0-p247@#{fetch(:application)}"
set :format,          :pretty

# set :log_level, :debug
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

set :user,        'fly'
set :port,        "8383"
set :deploy_to,   "/home/#{fetch(:user)}/"
set :use_sudo,    false
set :scm,         "git"
set :deploy_via,  :remote_cache # git pull vs. full clone
set :branch,      "master"

set :maintenance_template_path, File.expand_path("../../lib/capistrano/tasks/templates/maintenance.html.erb", __FILE__)

set :pty, true
set :ssh_options, { forward_agent: true } # key passthrough for git repo

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
