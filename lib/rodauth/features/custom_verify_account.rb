module Rodauth
  Feature.define(:custom_verify_account, :CustomVerifyAccount) do
    include FastGettext::Translation
extend FastGettext::Translation
    depends :verify_account

    def verify_account_error_flash
      _("Unable to verify account")
    end

    error_flash _("Unable to resend verify account email"), 'verify_account_resend'

    notice_flash "Your account has been verified"
    notice_flash "An email has been sent to you with a link to verify your account", 'verify_account_email_sent'

    view 'verify-account', 'Verify Account'
    view 'verify-account-resend', 'Resend Verification Email', 'resend_verify_account'


  end
end
