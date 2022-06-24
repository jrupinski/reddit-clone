class Sub < ApplicationRecord
  include Sortable

  belongs_to :moderator, class_name: 'User'
  has_many :post_subs, dependent: :destroy
  has_many :posts, through: :post_subs

  validates :name, :description, presence: true
  validates :name, uniqueness: true

  def posts_sorted_by_user_score
    sort_by_votes(collection: posts.includes(:author), direction: 'desc')
  end
end
