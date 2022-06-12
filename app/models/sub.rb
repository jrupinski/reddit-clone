class Sub < ApplicationRecord
  belongs_to :moderator, class_name: 'User'
  has_many :post_subs, dependent: :destroy
  has_many :posts, through: :post_subs

  validates :title, :description, presence: true
  validates :title, uniqueness: true
end
