require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'associations' do
    it { should belong_to(:author) }
    it { should belong_to(:post) }
    it { should belong_to(:parent_comment).optional }
    it { should have_many(:child_comments) }
    it { should have_many(:votes) }
  end

  context 'validations' do
    it { should validate_presence_of(:content) }
  end
end
