FactoryGirl.define do
  factory :project_badge do
    name { Faker::Lorem.word }
    image { Faker::Internet.url }
    description { Faker::Lorem.word }
    criteria { Faker::Lorem.word }

    factory :project_badge_granted do
      transient do
        collaboration_count 3
      end

      after(:create) do |badge, evaluator|
        create_list(:collaboration, evaluator.collaboration_count, project_badges: [badge])
      end
    end
  end
end