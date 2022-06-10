FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    content { Faker::Lorem.paragraph }
    author factory: :user

    before(:create) do |post|
      post.subs << build(:post_sub, post:).sub
    end
  end
end
