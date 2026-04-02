require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  describe "GET 'show'" do
    before(:each) do
      @user = create(:user)
    end

    it 'should be successful' do
      get :show, params: { id: @user }
      expect(response).to be_successful
    end

    it 'should find the right user' do
      get :show, params: { id: @user }
      expect(assigns(:user)).to eq(@user)
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user = create(:user)
      test_sign_in(@user)
    end

    it 'should be successful' do
      get :edit, params: { id: @user }
      expect(response).to be_successful
    end
  end

  describe "GET 'index'" do
    describe 'for non-signed-in users' do
      it 'should deny access' do
        get :index
        expect(response).to redirect_to(signin_path)
        expect(flash[:notice]).to match(/sign in/i)
      end
    end

    describe 'for signed-in users' do
      before(:each) do
        @user = test_sign_in(create(:user))
        second = create(:user, email: 'another@example.com')
        third = create(:user, email: 'another@example.net')
        @users = [@user, second, third]
      end

      it 'should be successful' do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe "GET 'new'" do
    it 'should be successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST 'create'" do
    describe 'failure' do
      before(:each) do
        @attr = { name: '', email: '', password: '',
                  password_confirmation: '' }
      end

      it 'should not create a user' do
        expect do
          post :create, params: { user: @attr }
        end.not_to change(User, :count)
      end

      it "should render the 'new' page" do
        post :create, params: { user: @attr }
        expect(response).to render_template('new')
      end
    end

    describe 'success' do
      before(:each) do
        @attr = { name: 'New User', email: 'user@foo.com',
                  password: 'foobar', password_confirmation: 'foobar' }
      end

      it 'should create a user' do
        expect do
          post :create, params: { user: @attr }
        end.to change(User, :count).by(1)
      end

      it 'should redirect to the user show page' do
        post :create, params: { user: @attr }
        expect(response).to redirect_to(user_path(assigns(:user)))
      end

      it 'should have a welcome message' do
        post :create, params: { user: @attr }
        expect(flash[:success]).to match(/welcome to the sample app/i)
      end

      it 'should sign the user in' do
        post :create, params: { user: @attr }
        expect(controller).to be_signed_in
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = create(:user)
      test_sign_in(@user)
    end

    describe 'failure' do
      before(:each) do
        @attr = { email: '', name: '', password: '', password_confirmation: '' }
      end

      it "should render the 'edit' page" do
        put :update, params: { id: @user, user: @attr }
        expect(response).to render_template('edit')
      end
    end

    describe 'success' do
      before(:each) do
        @attr = { name: 'New name', email: 'new@email.com', password: 'foobar',
                  password_confirmation: 'foobar' }
      end

      it 'should change the users attributes' do
        put :update, params: { id: @user, user: @attr }
        @user.reload
        expect(@user.name).to eq(@attr[:name])
        expect(@user.email).to eq(@attr[:email])
      end

      it 'should redirect to the user show page' do
        put :update, params: { id: @user, user: @attr }
        expect(response).to redirect_to(user_path(@user))
      end

      it 'should have a flash message' do
        put :update, params: { id: @user, user: @attr }
        expect(flash[:success]).to match(/updated/)
      end
    end
  end

  describe 'authentication of edit/update pages' do
    before(:each) do
      @user = create(:user)
    end

    describe 'for non-signed in users' do
      it 'should deny access to edit' do
        get :edit, params: { id: @user }
        expect(response).to redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, params: { id: @user, user: {} }
        expect(response).to redirect_to(signin_path)
      end
    end

    describe 'for signed in users' do
      before(:each) do
        wrong_user = create(:user, email: 'foobarski@user.net')
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, params: { id: @user }
        expect(response).to redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, params: { id: @user, user: {} }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = create(:user)
    end

    describe 'as a non-signed-in user' do
      it 'should deny access' do
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to(signin_path)
      end
    end

    describe 'as a non-admin user' do
      it 'should protect the page' do
        test_sign_in(@user)
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to(root_path)
      end
    end

    describe 'as an admin user' do
      before(:each) do
        admin = create(:user, email: 'admin@example.com', admin: true)
        test_sign_in(admin)
      end

      it 'should not destroy admin user' do
        @user = create(:user, email: 'admin1@example.com', admin: true)
        delete :destroy, params: { id: @user }
        expect(flash[:error]).to match(/delete yourself/i)
      end

      it 'should destroy the user' do
        expect do
          delete :destroy, params: { id: @user }
        end.to change(User, :count).by(-1)
      end

      it 'should redirect to the users page' do
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to(users_path)
      end
    end
  end

  describe 'follow pages' do
    describe 'when not signed in' do
      it "should protect 'following'" do
        get :following, params: { id: 1 }
        expect(response).to redirect_to(signin_path)
      end

      it "should protect 'followers'" do
        get :followers, params: { id: 1 }
        expect(response).to redirect_to(signin_path)
      end
    end

    describe 'when signed in' do
      before(:each) do
        @user = test_sign_in(create(:user))
        @other_user = create(:user, email: generate(:email))
        @user.follow!(@other_user)
      end

      it 'should show user following' do
        get :following, params: { id: @user }
        expect(response).to be_successful
      end

      it 'should show user followers' do
        get :followers, params: { id: @other_user }
        expect(response).to be_successful
      end
    end
  end
end
