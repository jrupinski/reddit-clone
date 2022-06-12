class Sub < ApplicationRecord
  belongs_to :moderator, class_name: 'User'
  has_many :post_subs, dependent: :destroy
  has_many :posts, through: :post_subs

  validates :name, :description, presence: true
  validates :name, uniqueness: true
end
