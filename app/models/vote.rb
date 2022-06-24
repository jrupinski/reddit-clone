class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, :user, presence: true
  validates_uniqueness_of :user_id, scope: :votable
  validates :value, numericality: { only_integer: true }
  validates :value, inclusion: { in: [-1, 1] }
end
