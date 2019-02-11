module Rodauth
  Feature.define(:custom_verify_account_grace_period, :CustomVerifyAccountGracePeriod) do
    include FastGettext::Translation
    extend FastGettext::Translation

    depends :verify_account_grace_period

    def verify_account_grace_period_error_flash
      _("Cannot change login for unverified account. Please verify this account before changing the login.", "unverified_change_login")
    end

  end
end
