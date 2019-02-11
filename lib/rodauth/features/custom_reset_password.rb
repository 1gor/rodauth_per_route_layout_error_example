module Rodauth
  Feature.define(:custom_reset_password, :CustomResetPassword) do
    extend FastGettext::Translation
    include FastGettext::Translation
    depends :reset_password

    def reset_password_redirect
      prefix+'/login'
    end

    def reset_password_email_sent_redirect
      '/reset-password-request'
    end

    def reset_password_notice_flash
      _("Your password has been reset")
    end

    def reset_password_email_sent_notice_flash
      _("An email has been sent to you with a link to reset the password for your account")
    end

    def reset_password_error_flash
      _("There was an error resetting your password")
    end

    def reset_password_request_error_flash
      _("There was an error requesting a password reset")
    end

    def reset_password_view
      view 'reset-password', s_('Title|Reset password')
    end

    def reset_password_request_view
      view 'reset-password-request', s_('Title|Request password reset')
    end

    def reset_password_button
      s_('Button|Reset password')
    end

    def reset_password_request_button
      s_('Button|Request password reset')
    end

    def no_matching_reset_password_key_message
      _("invalid password reset key")
    end

    def reset_password_email_subject
      s_('EmailSubject|Reset password')
    end

    def reset_password_request_link
      text = _("Forgot password?")
      "<p><a href=\"#{prefix}/#{reset_password_request_route}\">#{text}</a></p>"
    end

    def password_label
      if request.matched_path.match /reset-password/
        s_("Label|New password")
      else
        super
      end
    end


  end
end
