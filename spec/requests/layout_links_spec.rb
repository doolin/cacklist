require 'spec_helper'

RSpec.describe 'LayoutLinks', type: :request do
  it "should have a Home page at '/'" do
    get '/'
    expect(response).to be_successful
  end

  it "should have a signup page at '/signup'" do
    get '/signup'
    expect(response).to be_successful
  end

  it "should have a contact page at '/contact'" do
    get '/contact'
    expect(response).to be_successful
  end

  it "should have an about page at '/about'" do
    get '/about'
    expect(response).to be_successful
  end

  it "should have a help page at '/help'" do
    get '/help'
    expect(response).to be_successful
  end
end
