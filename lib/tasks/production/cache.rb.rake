namespace :cache do

  namespace :fragments do
    desc "Delete fragment caches"
    task delete: :environment do
      ['/admin/fares', '/user/fares'].each do |fragment_path|
        puts "Delete #{fragment_path} cache"
        ActionController::Base.new.expire_fragment(fragment_path)
      end
    end
  end

end

namespace :deploy do

  task :after_deploy, :env, :app_name, :local_branch, :remote_branch do |t, args|
    app_name = args[:app_name]

    FileUtils.cd Rails.root do
      puts "Delete fragment cache for #{app_name}"
      puts `heroku run --app #{app_name} rake cache:fragments:delete`
    end
  end

end
