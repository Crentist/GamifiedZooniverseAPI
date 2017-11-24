require 'faker'

FactoryGirl.define do
  factory :badge do
    name { Faker::Lorem.word }
    image { Faker::Internet.url }
    description { Faker::Lorem.word }
    criteria { Faker::Lorem.word }
    #user

    factory :generic_badge_granted do
      transient do
        user_count 3
      end

      after(:create) do |badge, evaluator|
        create_list(:user, evaluator.user_count, badges: [badge])
      end
    end


  end
end