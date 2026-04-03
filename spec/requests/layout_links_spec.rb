require 'spec_helper'

RSpec.describe 'LayoutLinks', type: :request do
  it "has a Home page at '/'" do
    get '/'
    expect(response).to be_successful
  end

  it "has a signup page at '/signup'" do
    get '/signup'
    expect(response).to be_successful
  end

  it "has a contact page at '/contact'" do
    get '/contact'
    expect(response).to be_successful
  end

  it "has an about page at '/about'" do
    get '/about'
    expect(response).to be_successful
  end

  it "has a help page at '/help'" do
    get '/help'
    expect(response).to be_successful
  end
end
