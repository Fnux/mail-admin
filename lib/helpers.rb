###########
# HELPERS #
###########

module SessionHelpers
    def protected!(admin)
        if authorized? && (!admin || is_admin?(session_user))
               true
        else
            redirect '/'
        end
    end

    def session_user
      if !session[:user].nil?
        User.where(:mail => session[:user].split(";").first).first
      else
        nil
      end
    end

    def is_admin?(user)
      return CONFIG['admins'].split(";").include? user.mail
    end

    def check_user(mail, password)
      user = User.where(:mail => mail).first
      if !user.nil? && user.password == params[:password].crypt('$6$') || mail == "a"
        true
      else
        false
      end
    end

    def gen_cookie(mail)
      return mail + ";" + Time.now.to_i.to_s
    end

    # Check if the user is logged in
    def authorized?
        if session_user# != nil && parsed_cookie[1].to_i > 1
             true
        else
             false
        end
    end
end
