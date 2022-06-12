class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :post_subs, dependent: :destroy
  has_many :subs, through: :post_subs
  has_many :comments, dependent: :destroy

  validates :title, :subs, presence: true
end
