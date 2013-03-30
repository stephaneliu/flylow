namespace :deploy do

  task :after_deploy, :env, :app_name, :local_branch, :remote_branch do |t, args|
    env           = args[:env]
    app           = args[:app_name]
    local_branch  = args[:local_branch]
    remote_branch = args[:remote_branch]
    release_name  = "#{app_name}_release_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"

    FileUtils.cd Rails.root do
      puts `git tag -a #{release_name} -m 'Tag release'`
      puts `git push --tags #{remote_branch}`
    end
  end

end
