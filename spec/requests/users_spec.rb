require 'spec_helper'

RSpec.describe 'Users', type: :request do
  describe 'signup' do
    describe 'failure' do
      it 'should not make a new user' do
        expect do
          post '/users', params: { user: { name: '', email: '', password: '',
                                           password_confirmation: '' } }
        end.not_to change(User, :count)
        expect(response.body).to include('error')
      end
    end

    describe 'success' do
      it 'should make a new user' do
        expect do
          post '/users', params: { user: { name: 'Example User', email: 'user@example.com',
                                           password: 'foobar', password_confirmation: 'foobar' } }
        end.to change(User, :count).by(1)
        expect(response).to redirect_to(user_path(User.last))
      end
    end
  end
end
