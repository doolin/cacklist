require 'spec_helper'

RSpec.describe RelationshipsController, type: :controller do
  describe 'access control' do
    it 'requires signin for create' do
      post :create
      expect(response).to redirect_to(signin_path)
    end

    it 'requires signin for destroy' do
      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do
    before do
      @user = test_sign_in(create(:user))
      @followed = create(:user, email: generate(:email))
    end

    it 'creates a relationship' do
      expect do
        post :create, params: { relationship: { followed_id: @followed } }
        expect(response).to be_redirect
      end.to change(Relationship, :count).by(1)
    end

    it 'creates a relationship using Ajax' do
      expect do
        post :create, params: { relationship: { followed_id: @followed } }, xhr: true
        expect(response).to be_successful
      end.to change(Relationship, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @user = test_sign_in(create(:user))
      @followed = create(:user, email: generate(:email))
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by(followed_id: @followed)
    end

    it 'destroys a relationship' do
      expect do
        delete :destroy, params: { id: @relationship }
        expect(response).to be_redirect
      end.to change(Relationship, :count).by(-1)
    end

    it 'destroys a relationship using Ajax' do
      expect do
        delete :destroy, params: { id: @relationship }, xhr: true
        expect(response).to be_successful
      end.to change(Relationship, :count).by(-1)
    end
  end
end
