class Comment < ApplicationRecord
  include Votable
  include Sortable

  belongs_to :post
  belongs_to :author, class_name: 'User'
  belongs_to :parent_comment, class_name: 'Comment', foreign_key: 'parent_comment_id', optional: true
  has_many :child_comments, class_name: 'Comment', foreign_key: 'parent_comment_id'

  validates :content, presence: true
end
