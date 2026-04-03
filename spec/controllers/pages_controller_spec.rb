require 'spec_helper'

RSpec.describe PagesController, type: :controller do
  render_views

  describe "GET 'home'" do
    describe 'when not signed in' do
      before do
        get :home
      end

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    describe 'when signed in' do
      before do
        @user = create(:user)
        test_sign_in(@user)
        create(:micropost, user: @user)
        create(:micropost, user: @user)
        create(:micropost, user: @user)
        other_user = create(:user, email: generate(:email))
        other_user.follow!(@user)
      end

      it 'is successful' do
        get :home
        expect(response).to be_successful
      end
    end
  end

  describe "GET 'contact'" do
    it 'is successful' do
      get 'contact'
      expect(response).to be_successful
    end
  end

  describe "GET 'about'" do
    it 'is successful' do
      get 'about'
      expect(response).to be_successful
    end
  end

  describe "GET 'help'" do
    it 'is successful' do
      get 'help'
      expect(response).to be_successful
    end
  end

  describe "GET 'profile'" do
    it 'is successful' do
      get 'profile'
      expect(response).to be_successful
    end
  end
end
