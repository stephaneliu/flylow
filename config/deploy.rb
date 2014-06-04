require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

if RUBY_PLATFORM =~ /darwin/
  id = "/Volumes/4T_home/sliu/.ssh/id_rsa"
else
  id = "/home/sliu/.ssh/id_rsa"
end

set :term_mode,    :pretty
set :application,  "flylow"
set :user,         'fly'
set :ruby_version, "ruby-2.1.2"

# Optional settings:
set :identity_file,  id
set :ssh_options,    '-A' # key passthrough for git repo
set :port,           "3838"

set :domain,      "flylow.pixelatedpath.com"
set :deploy_to,   "/home/#{user}/#{application}"
set :app_path,    "#{deploy_to}/#{current_path}"
set :repository,  "git@github.com:stephaneliu/hal_fare.git"
set :branch,      "master"

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/application.yml', 'log', 'tmp']


# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # queue! %[source "/usr/local/share/chruby/chruby.sh"]
  # queue! %[chruby "#{ruby_version}"]
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]
  queue! %[touch "#{deploy_to}/shared/tmp/pids/unicorn.pid"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> ###### Be sure to edit 'shared/config/database.yml'. ######"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do

		to :prepare do
			invoke :stop_async_services
		end

    # Put things that will set up an empty directory into a fully set-up instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
			invoke :start_async_services
      queue "service unicorn_hicrane restart"
    end
  end
end

task start_async_services: :environment  do
  # queue %[echo "--------> Starting delayed_job"]
	# queue %[cd "#{deploy_to}/current" ; RAILS_ENV=production bin/delayed_job start]
end

task stop_async_services: :environment  do
  # queue %[echo "--------> Stopping delayed_job"]
	# queue %[cd "#{deploy_to}/current" ; RAILS_ENV=production bin/delayed_job stop]
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
