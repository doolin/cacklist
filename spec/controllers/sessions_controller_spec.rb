require 'spec_helper'

RSpec.describe SessionsController, type: :controller do
  render_views

  describe "GET 'new'" do
    it 'is successful' do
      get 'new'
      expect(response).to be_successful
    end
  end

  describe "POST 'create'" do
    describe 'invalid signin' do
      before do
        @attr = { email: 'email@example.com', password: 'invalid' }
      end

      it 're-renders the new page' do
        post :create, params: { session: @attr }
        expect(response).to render_template('new')
      end
    end

    describe 'with valid email and password' do
      before do
        @user = create(:user)
        @attr = { email: @user.email, password: @user.password }
      end

      it 'signs the user in' do
        post :create, params: { session: @attr }
        expect(controller.current_user).to eq(@user)
        expect(controller).to be_signed_in
      end

      it 'redirects to the user show page' do
        post :create, params: { session: @attr }
        expect(response).to redirect_to(user_path(@user))
      end
    end
  end

  describe "DELETE 'destroy'" do
    it 'signs a user out' do
      test_sign_in(create(:user))
      delete :destroy
      expect(controller).not_to be_signed_in
      expect(response).to redirect_to(root_path)
    end
  end
end
