module Rodauth
  Feature.define(:custom_login, :CustomLogin) do
    include Logging
    include FastGettext::Translation
    extend FastGettext::Translation

    depends :login, :base

    def login_notice_flash
      _("You have been logged in")
      false
    end

    def login_error_flash
      _("There was an error logging in")
    end

    def login_view
      view 'login', s_('Title|Login')
    end

    def login_button
      s_("Button|Login")
    end

    def already_logged_in
      # If we are forwarded here by some feature that displays a message,
      # Make sure we preserve this message while redirecting the user
      flash = flash
      redirect default_redirect
    end

    def login_redirect
      return_to = session.delete(:return_to)
      logger.debug "return_to is now #{session[:return_to]}"
      return_to || super
    end


  end
end
