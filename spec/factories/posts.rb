FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    content { Faker::Lorem.paragraph }
    author factory: :user
    sub
  end
end
