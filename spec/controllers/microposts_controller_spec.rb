require 'spec_helper'

RSpec.describe MicropostsController, type: :controller do
  render_views

  describe 'access control' do
    it "denies access to 'create'" do
      post :create
      expect(response).to redirect_to(signin_path)
    end

    it "denies access to 'destroy'" do
      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do
    before do
      @user = test_sign_in(create(:user))
    end

    describe 'failure' do
      before do
        @attr = { content: '' }
      end

      it 'does not create a micropost' do
        expect do
          post :create, params: { micropost: @attr }
        end.not_to change(Micropost, :count)
      end

      it 'renders the home page' do
        post :create, params: { micropost: @attr }
        expect(response).to render_template('pages/home')
      end
    end

    describe 'success' do
      before do
        @attr = { content: 'Lorem ipsum' }
      end

      it 'creates a micropost' do
        expect do
          post :create, params: { micropost: @attr }
        end.to change(Micropost, :count).by(1)
      end

      it 'redirects to the home page' do
        post :create, params: { micropost: @attr }
        expect(response).to redirect_to(root_path)
      end

      it 'has a flash message' do
        post :create, params: { micropost: @attr }
        expect(flash[:success]).to match(/micropost created/i)
      end
    end
  end

  describe "DELETE 'destroy'" do
    describe 'for an unauthorized user' do
      before do
        @user = create(:user)
        wrong_user = create(:user, email: generate(:email))
        test_sign_in(wrong_user)
        @micropost = create(:micropost, user: @user)
      end

      it 'denies access' do
        delete :destroy, params: { id: @micropost }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'for an authorized user' do
      before do
        @user = test_sign_in(create(:user))
        @micropost = create(:micropost, user: @user)
      end

      it 'destroys the micropost' do
        expect do
          delete :destroy, params: { id: @micropost }
        end.to change(Micropost, :count).by(-1)
      end
    end
  end
end
