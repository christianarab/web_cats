class Helpers
  class Profile
    def self.has_cat?(session)
      if session.cat
        true
      else
        nil
      end
    end
  end

  class Login
    def self.current_user(session)
      @user = User.find_by_id(session[:email])
      @user
    end

    def self.is_logged_in?(session)
      !!session[:email]
    end
  end
end