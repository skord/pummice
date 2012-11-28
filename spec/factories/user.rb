FactoryGirl.define do
  factory :user, aliases: [:creator] do
    sequence(:email) {|n| "person#{n}@example.com"}
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    password 'please'
    password_confirmation 'please'
  end
end
