class Sub < ApplicationRecord
  belongs_to :moderator, class_name: 'User'
  has_many :posts, through: :post_subs

  validates :title, :description, presence: true
end
