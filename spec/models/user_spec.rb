require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  context 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }

    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:session_token) }

    it { should validate_length_of(:password).is_at_least(6) }
  end

  context 'associations' do
    it { should have_many(:posts) }
    it { should have_many(:subs) }
  end

  it 'creates a password when given a password string' do
    new_user = build(:user, password: 'password')
    expect(new_user.password_digest).to_not be_nil
  end

  describe '#is_password?' do
    it 'verifies if password is wrong' do
      expect(user.is_password?('wrong password')).to be false
    end

    it 'verifies if password is correct' do
      expect(user.is_password?('password')).to be true
    end
  end

  describe '::find_by_credentials' do
    it 'returns User if credentials are correct' do
      expect(User.find_by_credentials(username: user.username, password: user.password)).to eq user
    end

    it 'returns nil if credentials are wrong' do
      expect(User.find_by_credentials(username: user.username, password: 'wrong password')).to be_nil
      expect(User.find_by_credentials(username: 'unknown_user', password: 'wrong password')).to be_nil
    end
  end

  context 'session management' do
    describe '::generate_session_token' do
      it { expect(User.generate_session_token).to_not be_nil }
    end

    describe '#reset_session_token' do
      it 'generates a new session token and assigns it to user' do
        user.valid?
        old_session_token = user.session_token
        user.reset_session_token!
        expect(user.session_token).to_not eq old_session_token
      end
    end
  end
end
