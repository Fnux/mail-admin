module SessionHelpers
  # Check if the user is logged in
  def signed_in?
    if get_session_user()
      true
    else
      false
    end
  end

  # Protect a page
  def protected!(admin_required)
    if signed_in? && (!admin_required || is_admin?(get_session_user))
      true
    else
      redirect (CONFIG['prefix'] + '/')
    end
  end

  # Get the user related to the session cookie
  def get_session_user
    if !session[:user].nil?
      User.where(:mail => session[:user].split(";").first).first
    else
      nil
    end
  end

  # Session cookie
  def gen_cookie(mail)
    return mail + ";" + Time.now.to_i.to_s
  end

  def is_admin?(user)
    return CONFIG['admins'].split(";").include? user.mail
  end

  # Check user IDs
  def check_user(mail, password)
    user = User.where(:mail => mail).first
    if !user.nil? && user.password == password.crypt('$6$' + CONFIG['salt'])
      true
    else
      false
    end
  end
end
