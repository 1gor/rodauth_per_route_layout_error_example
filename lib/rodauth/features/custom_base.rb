module Rodauth
  Feature.define(:custom_base, :CustomBase) do
    extend FastGettext::Translation
    include FastGettext::Translation
    depends :base

    error_flash _("Please login to continue"), 'require_login'

    auth_value_method :invalid_password_message, _("invalid password")
    auth_value_method :no_matching_login_message, _("no matching login")
    auth_value_method :login_label, s_('Label|Login')
    auth_value_method :password_label, s_('Label|Password')
    auth_value_method :unverified_account_message, _("unverified account, please verify account before logging in")
    auth_value_method :cancel_button_text, s_("Button|Cancel")


    # def cancel_button_text
    #   s_("Button|Cancel")
    # end

    def default_redirect
      scope.root_path
    end

    def login_required
      # logger.debug "setting return_to cookie"
      request.session[:return_to] = request.fullpath
      super
    end

    def clear_session
      # session.keys.each do |k|
      #   session.delete(k) unless k.to_s == 'return_to'
      # end
      return_to = session[:return_to]
      super
      session[:return_to] = return_to
      # logger.debug "return to is #{return_to}"
    end


  end
end
