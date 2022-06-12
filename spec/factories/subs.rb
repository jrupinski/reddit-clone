FactoryBot.define do
  factory :sub do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    moderator { association(:user) }
  end
end
