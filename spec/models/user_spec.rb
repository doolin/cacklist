require 'spec_helper'

RSpec.describe User, type: :model do
  before do
    @attr = {
      name: 'Example User',
      email: 'user@example.com',
      password: 'foobar',
      password_confirmation: 'foobar'
    }
  end

  it 'creates a new instance given valid attributes' do
    User.create!(@attr)
  end

  it 'requires a name' do
    no_name_user = User.new(@attr.merge(name: ''))
    expect(no_name_user).not_to be_valid
  end

  it 'requires an email address' do
    no_email_user = User.new(@attr.merge(email: ''))
    expect(no_email_user).not_to be_valid
  end

  it 'rejects names which are too long' do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(name: long_name))
    expect(long_name_user).not_to be_valid
  end

  it 'accepts valid email addresses' do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(email: address))
      expect(valid_email_user).to be_valid
    end
  end

  it 'rejects invalid email addresses' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(email: address))
      expect(invalid_email_user).not_to be_valid
    end
  end

  it 'rejects duplicate email addresses' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email).not_to be_valid
  end

  it 'rejects email addresses identical up to case' do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(email: upcased_email))
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email).not_to be_valid
  end

  describe 'password validations' do
    it 'requires a password' do
      expect(User.new(@attr.merge(password: '', password_confirmation: ''))).not_to be_valid
    end

    it 'requires a matching password confirmation' do
      expect(User.new(@attr.merge(password_confirmation: 'invalid'))).not_to be_valid
    end

    it 'rejects short passwords' do
      short = 'a' * 5
      hash = @attr.merge(password: short, password_confirmation: short)
      expect(User.new(hash)).not_to be_valid
    end

    it 'rejects long passwords' do
      long = 'a' * 41
      hash = @attr.merge(password: long, password_confirmation: long)
      expect(User.new(hash)).not_to be_valid
    end
  end

  describe 'password encryption' do
    before do
      @user = User.create!(@attr)
    end

    it 'has a password_digest attribute' do
      expect(@user).to respond_to(:password_digest)
    end

    it 'sets the password digest' do
      expect(@user.password_digest).not_to be_blank
    end

    describe 'authenticate method' do
      it 'returns nil on email/password mismatch' do
        wrong_password_user = User.authenticate(@attr[:email], 'wrongpass')
        expect(wrong_password_user).to be_nil
      end

      it 'returns nil for an email address with no user' do
        nonexistent_user = User.authenticate('bar@foo.com', @attr[:password])
        expect(nonexistent_user).to be_nil
      end

      it 'returns the user on email/password match' do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        expect(matching_user).to eq(@user)
      end
    end
  end

  describe 'admin attribute' do
    before do
      @user = User.create!(@attr)
    end

    it 'responds to admin' do
      expect(@user).to respond_to(:admin)
    end

    it 'is not an admin by default' do
      expect(@user).not_to be_admin
    end

    it 'is convertible to an admin' do
      @user.toggle!(:admin)
      expect(@user).to be_admin
    end
  end

  describe 'micropost associations' do
    before do
      @user = User.create(@attr)
      @mp1 = create(:micropost, user: @user, created_at: 1.day.ago)
      @mp2 = create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it 'has a microposts attribute' do
      expect(@user).to respond_to(:microposts)
    end

    it 'has the right microposts in the right order' do
      expect(@user.microposts).to eq([@mp2, @mp1])
    end

    it 'destroys associated microposts' do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        expect(Micropost.find_by(id: micropost.id)).to be_nil
      end
    end

    describe 'status feed' do
      it 'has a feed' do
        expect(@user).to respond_to(:feed)
      end

      it "includes the user's microposts" do
        expect(@user.feed).to include(@mp1)
        expect(@user.feed).to include(@mp2)
      end

      it "does not include a different user's microposts" do
        mp3 = create(:micropost,
                     user: create(:user, email: generate(:email)))
        expect(@user.feed).not_to include(mp3)
      end

      it 'includes the microposts of followed users' do
        followed = create(:user, email: generate(:email))
        mp3 = create(:micropost, user: followed)
        @user.follow!(followed)
        expect(@user.feed).to include(mp3)
      end
    end
  end

  describe 'relationships' do
    before do
      @user = User.create!(@attr)
      @followed = create(:user, email: generate(:email))
    end

    it 'has a relationships method' do
      expect(@user).to respond_to(:relationships)
    end

    it 'has a following method' do
      expect(@user).to respond_to(:following)
    end

    it 'has a following? method' do
      expect(@user).to respond_to(:following?)
    end

    it 'has a follow! method' do
      expect(@user).to respond_to(:follow!)
    end

    it 'follows another user' do
      @user.follow!(@followed)
      expect(@user).to be_following(@followed)
    end

    it 'includes the followed user in the following array' do
      @user.follow!(@followed)
      expect(@user.following).to include(@followed)
    end

    it 'has an unfollow! method' do
      expect(@followed).to respond_to(:unfollow!)
    end

    it 'unfollows a user' do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      expect(@user).not_to be_following(@followed)
    end

    it 'has a reverse_relationships method' do
      expect(@user).to respond_to(:reverse_relationships)
    end

    it 'has a followers method' do
      expect(@user).to respond_to(:followers)
    end

    it 'includes the follower in the followers array' do
      @user.follow!(@followed)
      expect(@followed.followers).to include(@user)
    end
  end
end
