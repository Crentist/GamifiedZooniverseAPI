require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:collaborator, :owner] do
    #handle { Faker::Lorem.word }
    sequence(:handle, 'a') { |n| "Gemini" + n }
    #badges
    #project_badges


    factory :user_with_5_collaborations do
      transient do
        collaborations_count 5
      end

      after(:create) do |user,evaluator|
        create_list(:collaboration, evaluator.collaborations_count, user: user)
      end
    end

    factory :user_with_2_owned_projects do
      transient do
        projects_count 2
      end

      after(:create) do |user,evaluator|
        create_list(:project, evaluator.projects_count, user: user)
      end
    end
  end
end