###########
# HELPERS #
###########

module SessionHelpers
    def protected!
        if authorized?
             true
        else
            redirect '/'
        end
    end

    def session_user
      return User.where(:mail => session[:user].split(";").first).first
    end

    def check_user(mail, password)
      user = User.where(:mail => mail).first
      if !user.nil? && user.password == params[:password].crypt('$6$')
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
        parsed_cookie = session[:user].split(";")
        if true #parsed_cookie[0] == true && parsed_cookie[1].to_date > 1
             true
        else
             false
        end
    end
end
