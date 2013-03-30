# list of environments and their heroku git remotes
ENVIRONMENTS = {
  staging: ['staging', 'flylow-staging'],
  production: ['heroku', 'flylow']
}

namespace :deploy do

  ENVIRONMENTS.each do |key, value|
    env           = key
    remote_branch = value.first
    app_name      = value.last

    desc "Deploying to #{env}"
    task env do
      local_branch = `git branch | grep ^* | awk '{ print $2 }'`.strip

      Rake::Task['deploy:before_deploy'].invoke(env, app_name, local_branch, remote_branch)
      Rake::Task['deploy:update_code'].invoke(env, app_name, local_branch, remote_branch)
      Rake::Task['deploy:after_deploy'].invoke(env, app_name, local_branch, remote_branch)
    end
  end

  task :before_deploy, :env, :app_name, :local_branch, :remote_branch do |t, args|
    env     = args[:env]
    branch  = args[:local_branch]

    puts "Deploying #{branch} to #{env}"

    # Ensure the user wants to deploy a non-master branch to production
    if env == :production && branch != 'master'
      print "Are you sure you want to deploy '#{branch}' to production? (y/n) " and STDOUT.flush
      char = $stdin.getc
      if char != ?y && char != ?Y
        puts "Deploy aborted"
        exit 
      end
    end
  end

  task :after_deploy, :env, :app_name, :local_branch, :remote_branch do |t, args|
    puts "Deployment Complete"
  end

  task :update_code, :env, :app_name, :local_branch, :remote_branch do |t, args|
    remote_branch = args[:env]
    local_branch  = args[:local_branch]

    FileUtils.cd Rails.root do
      puts "Updating #{remote_branch} with branch #{local_branch}"
      `git push #{remote_branch} +#{local_branch}:master`
    end
  end

end
