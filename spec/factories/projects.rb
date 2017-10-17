require 'faker'

FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.word }
    owner

    factory :project_with_15_collaborations do
      transient do
        collaborations_count 15
      end

      after(:create) do |project, evaluator|
        create_list(:collaboration, evaluator.collaborations_count, project: project)
      end
    end
  end
end