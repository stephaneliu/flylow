namespace :deploy do

  desc "Run migrations for production"
  task :after_deploy, :env, :app_name, :local_branch, :remote_branch do |t, args|
    app_name = args[:app_name]

    FileUtils.cd Rails.root do
      puts "Running migrations for #{app_name}"
      puts `heroku run --app #{app_name} rake db:migrate`
    end
  end

end
