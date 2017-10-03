require 'faker'

FactoryGirl.define do
  factory :project do
    name { Faker::Lorem.word }

    factory :project_with_5_collaborators do
      transient do
        #collaborators_count 5
        collaborations_count 15
      end

      after(:create) do |project, evaluator|
        #create_list(:collaborator, evaluator.collaborators_count, projects: [project])
        create_list(:collaboration, evaluator.collaborations_count, project: project)
      end
    end
  end
end