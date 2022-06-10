require 'rails_helper'

RSpec.describe PostSub, type: :model do
  context 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:sub) }
  end
end
