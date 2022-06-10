class User < ApplicationRecord
  validates :username, :email, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :username, :email, :session_token, uniqueness: true

  before_validation :ensure_session_token

  has_many :posts, inverse_of: :author, foreign_key: :author_id

  attr_reader :password

  def password=(password)
    @password = password

    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password_hashed = BCrypt::Password.new(password_digest)
    password_hashed.is_password?(password)
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    save!
    session_token
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def self.find_by_credentials(username:, password:)
    user = User.find_by(username:)

    user&.is_password?(password) ? user : nil
  end
end
