FactoryBot.define do
  factory :comment do
    post { nil }
    parent_comment_id { nil }
    author { nil }
    content { Faker::Lorem.paragraph }
  end
end
