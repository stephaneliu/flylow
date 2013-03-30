namespace :development do
  desc "Passing params to task test rake ask['something']"
  task :ask, :question do |t, args|
    question = args[:question]
    puts "I ask: #{question}"
  end
end
