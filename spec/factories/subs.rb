FactoryBot.define do
  factory :sub do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    moderator { association(:user) }
  end
end
