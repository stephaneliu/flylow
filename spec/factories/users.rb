# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
    
    factory :admin do
      after(:create) {|user| user.add_role(:admin)}
    end

    factory :vip do
      after(:create) {|user| user.add_role(:vip)}
    end

    factory :plain_user do
      after(:create) {|user| user.add_role(:user)}
    end
  end

end
