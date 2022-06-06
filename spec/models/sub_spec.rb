require 'rails_helper'

RSpec.describe Sub, type: :model do
  context 'associations' do
    it { should belong_to(:moderator) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
