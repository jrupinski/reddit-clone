class Post < ApplicationRecord
  include Votable
  include Sortable

  belongs_to :author, class_name: 'User'
  has_many :post_subs, dependent: :destroy
  has_many :subs, through: :post_subs
  has_many :comments, dependent: :destroy

  validates :title, :subs, presence: true

  #
  # Returns a hash of comments, and the parent comment they are assigned to.
  # Equals better performance than scanning through each comment and children of these (hash lookup is around O(1)).
  #
  # @return [Hash] Keys of parent_comment_id, Values of Comments
  #
  def comments_by_parent
    comments_by_parent = Hash.new { |hash, key| hash[key] = [] }

    comments_sorted_by_user_score.each do |comment|
      comments_by_parent[comment.parent_comment_id] << comment
    end

    comments_by_parent
  end

  def comments_sorted_by_user_score
    sort_by_votes(collection: comments.includes(:author), direction: 'asc')
  end
end
