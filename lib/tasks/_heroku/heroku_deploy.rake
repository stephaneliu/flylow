# list of environments and their heroku git remotes
ENVIRONMENTS = {
  staging: ['staging', 'flylow-staging'],
  production: ['heroku', 'flylow']
}

namespace :deploy do
  ENVIRONMENTS.each do |key, value|
    env, app_name = value.first, value.last
    desc "Deploy to #{env}"
    task env do
    current_branch = `git branch | grep \* | awk '{ print $2 }'`.strip

    Rake::Task['deploy:before_deploy'].invoke(env, app_name, current_branch)
    Rake::Task['deploy:update_code'].invoke(env, app_name, current_branch)
    Rake::Task['deploy:after_deploy'].invoke(env, app_name, current_branch)
  end
end

  task :before_deploy, :env, :app_name, :branch do |t, args|
    puts "Deploying #{args[:branch]} to #{args[:env]}"

    # Ensure the user wants to deploy a non-master branch to production
    if args[:env] == :production && args[:branch] != 'master'
      print "Are you sure you want to deploy '#{args[:branch]}' to production? (y/n) " and STDOUT.flush
      char = $stdin.getc
      if char != ?y && char != ?Y
        puts "Deploy aborted"
        exit 
      end
    end
  end

  task :after_deploy, :env, :app_name, :branch do |t, args|
    puts "Deployment Complete"
  end

  task :update_code, :env, :app_name, :branch do |t, args|
    FileUtils.cd Rails.root do
    puts "Updating #{ENVIRONMENTS[args[:env]]} with branch #{args[:branch]}"
    `git push #{ENVIRONMENTS[args[:env]]} +#{args[:branch]}:master`
    end
  end
end
