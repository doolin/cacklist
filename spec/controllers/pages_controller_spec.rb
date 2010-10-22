require 'spec_helper'

describe PagesController do

  render_views


  before(:each) do
    @base_title = "Cacklist"
  end

  describe "GET 'home'" do

    describe "for non-signed in users" do

      it "should be successful" do
	get 'home'
	response.should be_success
      end


      it "should have the right title" do
	get 'home'
	response.should have_selector("title",
				      :content => @base_title + " | Home")
      end

      it "should have signup button" do
	get :home
	response.should have_selector("a", :href => "/signup",
				      :content => "Sign up now!")
      end

    end

    describe "for signed-in users" do

      before(:each) do
	@user = Factory(:user)
	test_sign_in(@user)
        @micropost = Factory(:micropost, :user => @user)
	second = Factory(:micropost, :user => @user)
	third = Factory(:micropost, :user => @user)
	@microposts = [@micropost, second, third]
	45.times do
	  @microposts << Factory(:micropost, :user => @user)
	end
      end

      it "should have a sidebar" do
	get :home
	response.should have_selector("td", :class => "sidebar round")
      end

      it "should have the user's name for headline" do
	get :home
	response.should have_selector("h1", :content => "What's up?")
      end

      it "should paginate user's microposts" do
	get :home
	response.should have_selector("div.pagination")
	response.should have_selector("span.disabled", :content => "Previous")
	response.should have_selector("a", :href => "/?page=2",
				      :content => "2")
	response.should have_selector("a", :href => "/?page=2",
				      :content => "Next")
      end
    end


    describe "sidebar behavior" do

      it "should display singular with one micropost" do
	@user = Factory(:user)
	test_sign_in(@user)
        @micropost = Factory(:micropost, :user => @user)
	get :home
	response.should have_selector("td", :class => "sidebar round",
				      :content => "micropost")
      end

      it "should pluralize with more than one micropost" do
	@user = Factory(:user)
	test_sign_in(@user)
        @micropost = Factory(:micropost, :user => @user)
	second = Factory(:micropost, :user => @user)
	@microposts = [@micropost, second]
	get :home
	response.should have_selector("td", :class => "sidebar round",
				      :content => "microposts")
      end

    end

      


  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
				    :content => "Cacklist | Contact")
    end

  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
				    :content => "Cacklist | About")
    end

  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
				    :content => "Cacklist | Help")
    end

  end

  describe "GET 'profile'" do
    it "should be successful" do
      get 'profile'
      response.should be_success
    end

    it "should have the right title" do
      get 'profile'
      response.should have_selector("title",
				    :content => "Cacklist | Profile")
    end

  end

end
