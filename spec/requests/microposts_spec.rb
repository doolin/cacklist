require 'spec_helper'

RSpec.describe 'Microposts', type: :request do
  before(:each) do
    @user = create(:user)
    post '/sessions', params: { session: { email: @user.email, password: @user.password } }
  end

  describe 'creation' do
    describe 'failure' do
      it 'should not make a new micropost' do
        expect do
          post '/microposts', params: { micropost: { content: '' } }
        end.not_to change(Micropost, :count)
      end
    end

    describe 'success' do
      it 'should make a new micropost' do
        content = 'Lorem ipsum dolor sit amet'
        expect do
          post '/microposts', params: { micropost: { content: content } }
        end.to change(Micropost, :count).by(1)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
