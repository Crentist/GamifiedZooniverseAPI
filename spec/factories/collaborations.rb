require 'faker'

FactoryGirl.define do
  factory :collaboration do
    points { Faker::Number.number(2) }
    user
    project
  end
end