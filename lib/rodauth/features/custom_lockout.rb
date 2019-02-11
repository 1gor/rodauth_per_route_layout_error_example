module Rodauth
  Feature.define(:custom_lockout, :CustomLockout) do
extend FastGettext::Translation
    include FastGettext::Translation
    depends :lockout, :base

        # redirect(:require_login){"#{prefix}/login"}

    redirect :unlock_account
    redirect(:unlock_account_request){require_login_redirect}
    redirect(:unlock_account_email_recently_sent){require_login_redirect}


    def max_invalid_logins
      case ENV['RACK_ENV']
      when 'test'
        2
      else
#        100
        2
      end
    end

    def unlock_account_request_view
      view 'unlock-account-request', s_("Title|Request Account Unlock")
    end

    def unlock_account_view
      view 'unlock-account', s_('Title|Unlock Account')
    end

    def unlock_account_button
      s_('Button|Unlock Account')
    end

    def unlock_account_request_button
      s_('Button|Request Account Unlock')
    end

    def unlock_account_error_flash
      _("There was an error unlocking your account")
    end

    def login_lockout_error_flash
      _("This account is currently locked out and cannot be logged in to")
    end

    def unlock_account_notice_flash
      _("Your account has been unlocked")
    end

    def unlock_account_request_notice_flash
      _("An email has been sent to you with a link to unlock your account")
    end

    def no_matching_unlock_account_key_message
      _('No matching unlock account key')
    end

    def unlock_account_email_subject
      s_('Email|Unlock Account')
    end

  end
end
