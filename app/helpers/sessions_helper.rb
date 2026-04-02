module SessionsHelper
  def sign_in(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def sign_out
    current_user&.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user
    if (user_id = cookies.signed[:user_id])
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, notice: 'Please sign in to access this page.'
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
