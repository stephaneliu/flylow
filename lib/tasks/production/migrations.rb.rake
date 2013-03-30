namespace :deploy do
  task :after_deploy, :env, :app_name, :branch do |t, args|
    FileUtils.cd Rails.root do
      puts "Running migrations"
      `heroku run --app #{args[:app_name]} rake db:migrate`
    end
  end
end
