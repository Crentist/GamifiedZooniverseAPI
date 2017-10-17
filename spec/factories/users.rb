require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:collaborator, :owner] do
    zooniverseHandle { Faker::Lorem.word }


    factory :user_with_5_collaborations do
      transient do
        collaborations_count 5
      end

      after(:create) do |user,evaluator|
        byebug
        create_list(:collaboration, evaluator.collaborations_count, collaborator: user)
      end
    end
  end
end