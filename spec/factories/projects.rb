require 'faker'

FactoryGirl.define do
  factory :project do
    title { Faker::Lorem.word }
  end
end