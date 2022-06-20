FactoryBot.define do
  factory :comment do
    post { nil }
    author { nil }
    content { Faker::Lorem.paragraph }
  end
end
