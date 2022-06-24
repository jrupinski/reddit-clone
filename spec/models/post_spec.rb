require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'associations' do
    it { should belong_to(:author) }
    it { should have_many(:post_subs) }
    it { should have_many(:post_subs) }
    it { should have_many(:votes) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
  end
end
