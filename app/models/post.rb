class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :post_subs, dependent: :destroy
  has_many :subs, through: :post_subs
  has_many :comments, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, :subs, presence: true

  def top_level_comments
    comments.where(parent_comment_id: nil)
  end

  #
  # Returns a hash of comments, and the parent comment they are assigned to.
  # Equals better performance than scanning through each comment and children of these (hash lookup is around O(1)).
  #
  # @return [Hash] Keys of parent_comment_id, Values of Comments
  #
  def comments_by_parent
    comments_by_parent = Hash.new { |hash, key| hash[key] = [] }

    comments.includes(:author).each do |comment|
      comments_by_parent[comment.parent_comment_id] << comment
    end

    comments_by_parent
  end

  def user_score
    votes.pluck(:value).sum
  end
end
