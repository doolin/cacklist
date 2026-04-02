class PagesController < ApplicationController
  def home
    @title = 'Home'
    return unless signed_in?

    @micropost = Micropost.new
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def contact
    @title = 'Contact'
  end

  def about
    @title = 'About'
  end

  def help
    @title = 'Help'
  end

  def profile
    @title = 'Profile'
  end
end
