require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'associations' do
    it { should belong_to(:author) }
    it { should have_many(:post_subs) }
    it { should have_many(:subs).through(:post_subs) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
  end

  context '#top_level_comments' do
    let!(:post) { create(:post) }
    let!(:parent_comments) { create_list(:comment, 3, post: post, author: post.author)}
    let!(:child_comments) { create_list(:comment, 3, post: post, author: post.author, parent_comment_id: parent_comments.first.id) }

    it 'returns only parent comments of Post' do
      expect(post.top_level_comments.count).to eq(parent_comments.count)
      expect(post.top_level_comments).to eq(parent_comments)
    end
  end
end
