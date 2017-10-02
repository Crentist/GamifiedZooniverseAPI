require 'faker'

FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.word }

    factory :project_with_5_collaborators do
      transient do
        collaborators_count 5
      end

      after(:create) do |project, evaluator|
        create_list(:collaborator, evaluator.collaborators_count, projects: [project])
      end
    end
  end
end