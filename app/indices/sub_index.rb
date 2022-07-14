ThinkingSphinx::Index.define :sub, :with => :real_time do
  # fields
  indexes name, :sortable => true
  indexes description
  indexes moderator.username, :as => :moderator, :sortable => true

  # attributes
  has moderator_id, :type => :integer
  has created_at, :type => :timestamp
  has updated_at, :type => :timestamp
end
