require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:collaborator, :admin] do
    zooniverseHandle { Faker::Lorem.word }


    factory :user_with_5_collaborations do
      transient do
        collaborations_count 5
      end

      after(:create) do |user,evaluator|
        create_list(:collaboration, evaluator.collaborations_count, user: user)
      end
    end
  end
end