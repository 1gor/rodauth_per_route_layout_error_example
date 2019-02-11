module Rodauth
  Feature.define(:custom_create_account, :CustomCreateAccount) do
extend FastGettext::Translation
    include FastGettext::Translation
    depends :create_account

    def create_account_notice_flash
      _('Your account has been created')
    end

    def create_account_error_flash
      _("There was an error creating your account")
    end

    def create_account_view
      view 'create-account', s_('Title|Create Account')
    end

    def create_account_button
      s_("Button|Create Account")
    end

    def create_account_autologin
      true
    end

    def create_acount_redirect
      '/onboarding_url'
    end


    def create_account_link
      text = _('Create a New Account')
      "<p><a href=\"#{prefix}/#{create_account_route}\">#{text}</a></p>"
    end


    def save_account
      id = nil
      raised = raises_uniqueness_violation?{id = db[accounts_table].insert(account)}

      if raised
        @login_requirement_message = _('already an account with this login')
      end

      if id
        account[account_id_column] = id
      end

      id && !raised
    end



  end
end
