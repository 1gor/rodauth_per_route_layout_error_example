module Rodauth
  Feature.define(:custom_verify_login_change, :CustomVerifyLoginChange) do
    include FastGettext::Translation
extend FastGettext::Translation

    depends :verify_login_change

    def verify_login_change_error_flash
      _("Unable to verify login change")
    end

    def verify_login_change_notice_flash
      _("Your login change has been verified")
    end

    def verify_login_change_view
      view 'verify-login-change', s_('Title|Verify Login Change')
    end

    def verify_login_button
      s_('Button|Verify Login Change')
    end

    def no_matching_verify_login_change_key_message
      _("invalid verify login change key")
    end

    def verify_login_change_email_subject
     s_('Email|Verify Login Change')
    end

    def already_logged_in
      return nil if request.matched_path.match(/\/verify-login-change/)
      super
    end

  end

end
