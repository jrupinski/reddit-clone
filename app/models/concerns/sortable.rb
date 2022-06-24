module Sortable
  extend ActiveSupport::Concern

  def sort_by_votes(collection:, direction: 'desc')
    collection.left_joins(:votes)
              .group(:id)
              .order("SUM(votes.value) #{direction}")
  end
end
