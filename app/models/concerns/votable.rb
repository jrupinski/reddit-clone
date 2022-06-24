module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def user_score
    votes.pluck(:value).sum
  end
end
