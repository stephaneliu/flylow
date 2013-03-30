namespace :cache do
  namespace :fragments do
    # expire fragment cache
    task delete: :environment do 
      ['/admin/fares', '/user/fares'].each do |fragment_path|
        ActionController::Base.new.expire_fragment(fragment_path)
      end
    end
  end
end

namespace :deploy do
  task :after_deploy, :env, :app_name, :branch do |t, args|
    `heroku run --app #{args[:app_name]} rake cache:fragments:delete`
  end
end
