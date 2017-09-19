require 'faker'

FactoryGirl.define do
  factory :user do
    zooniverseHandle { Faker::Lorem.word }
  end
end