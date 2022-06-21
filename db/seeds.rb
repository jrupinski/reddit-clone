# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

# Users
FactoryBot.create_list(:user, 5)

# Subs
User.all.each do |user|
  FactoryBot.create_list(:sub, 2, moderator: user)
end

# Posts
Sub.all.each do |sub|
  random_user_id = rand(1..User.count)
  sub_ids = [sub.id]
  2.times do
    random_sub_id = rand(1..Sub.count)
    sub_ids << random_sub_id
  end

  posts = FactoryBot.build_list(:post, 3, sub_ids:, author: User.find(random_user_id))
  # workaround for duplicate keys for post_subs
  posts.each do |post|
    new_post = Post.new
    new_post.title = post.title
    new_post.url = post.url
    new_post.content = post.content
    new_post.author = post.author
    new_post.subs = Sub.where(id: [sub_ids])
    new_post.save
  end
end

# Comments
Post.all.each do |post|
  random_user_id = rand(1..User.count)
  FactoryBot.create_list(:comment, 5, post:, author: User.find(random_user_id))
end

# Nested Comments
Comment.all.each do |comment|
  random_user_id = rand(1..User.count)
  first_level_deep_comments = FactoryBot.create_list(:comment, 2, parent_comment_id: comment.id, post: comment.post, author: User.find(random_user_id))
  first_level_deep_comments.each do |comment|
    FactoryBot.create(:comment, parent_comment_id: comment.id, post: comment.post, author: User.find(random_user_id))
  end
end

