require 'spec_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = create(:user)
    @attr = { content: 'value for content' }
  end

  it 'creates a new instance given valid attributes' do
    @user.microposts.create!(@attr)
  end

  describe 'user associations' do
    before do
      @micropost = @user.microposts.create(@attr)
    end

    it 'has a user attribute' do
      expect(@micropost).to respond_to(:user)
    end

    it 'has the right associated user' do
      expect(@micropost.user_id).to eq(@user.id)
      expect(@micropost.user).to eq(@user)
    end
  end

  describe 'validations' do
    it 'requires a user id' do
      expect(Micropost.new(@attr)).not_to be_valid
    end

    it 'requires nonblank content' do
      expect(@user.microposts.build(content: ' ')).not_to be_valid
    end

    it 'rejects long content' do
      expect(@user.microposts.build(content: 'a' * 141)).not_to be_valid
    end
  end

  describe 'from_users_followed_by' do
    before do
      @other_user = create(:user, email: generate(:email))
      @third_user = create(:user, email: generate(:email))

      @user_post = @user.microposts.create!(content: 'bar')
      @other_post = @other_user.microposts.create!(content: 'bar')
      @third_post = @third_user.microposts.create!(content: 'baz')

      @user.follow!(@other_user)
    end

    it 'has a from_users_followed_by class method' do
      expect(Micropost).to respond_to(:from_users_followed_by)
    end

    it "includes the followed user's microposts" do
      expect(Micropost.from_users_followed_by(@user)).to include(@other_post)
    end

    it "includes the user's own microposts" do
      expect(Micropost.from_users_followed_by(@user)).to include(@user_post)
    end

    it "does not include an unfollowed user's microposts" do
      expect(Micropost.from_users_followed_by(@user)).not_to include(@third_post)
    end
  end
end
