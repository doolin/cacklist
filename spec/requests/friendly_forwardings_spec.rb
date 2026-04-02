require 'spec_helper'

RSpec.describe 'FriendlyForwardings', type: :request do
  it 'should forward to the required page after signin' do
    user = create(:user)
    get edit_user_path(user)
    expect(response).to redirect_to(signin_path)
    post '/sessions', params: { session: { email: user.email, password: user.password } }
    expect(response).to redirect_to(edit_user_path(user))
  end
end
