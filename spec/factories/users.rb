require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:collaborator, :admin] do
    zooniverseHandle { Faker::Lorem.word }
  end
end