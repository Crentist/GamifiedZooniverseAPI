require 'faker'

FactoryGirl.define do
  factory :collaboration do
    points { Faker::Number.number(2) }
    classification_count { Faker::Number.number(3) }
    user
    project
    project_badges
  end
end