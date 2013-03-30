namespace :deploy do

  task :before_deploy, :env, :app_name, :local_branch, :remote_branch do |t, args|
    app_name = args[:app_name]

    FileUtils.cd Rails.root do
      puts "Putting #{app_name} into maintenance mode"
      puts `heroku maintenance:on --app #{app_name}`
    end
  end

end

namespace :deploy do

  task :after_deploy, :env, :app_name, :local_branch, :remote_branch do |t, args|
    app_name = args[:app_name]

    FileUtils.cd Rails.root do
      puts "Taking #{app_name} out of maintenance mode"
      puts `heroku maintenance:off --app #{app_name}`
    end
  end

end
