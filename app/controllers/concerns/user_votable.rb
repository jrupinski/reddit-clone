module UserVotable
  extend ActiveSupport::Concern

  included do
    helper_method :add_vote
  end

  def add_vote(object:, value:)
    vote = object.votes.find_or_initialize_by(user: current_user)

    if vote.persisted?
      vote.destroy
      flash[:notice] = ['Vote removed']
    elsif vote.update(value:)
      notice_value = (value.positive? ? 'Upvote' : 'Downvote')
      flash[:notice] = ["#{notice_value} saved!"]
    else
      flash[:errors] = vote.errors.full_messages
    end

    object_path = polymorphic_path(object)
    redirect_back(fallback_location: object_path)
  end
end
