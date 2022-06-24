require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'associations' do
    it { should belong_to(:votable) }
    it { should belong_to(:user) }
    it { validate_uniqueness_of(:votable).scoped_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:value) }
    it { should validate_numericality_of(:value).only_integer }
    it { should validate_inclusion_of(:value).in_array([-1, 1]) }
  end
end
