module Rodauth
  Feature.define(:custom_change_login, :CustomChangeLogout) do
extend FastGettext::Translation
    include FastGettext::Translation
    include Logging
    depends :change_login

    def change_login_notice_flash
      _("We have sent you a message with a link to confirm your new email.")
    end

    def change_login_error_flash
      _('There was an error changing your login')
    end

    def change_login_view
      view 'change-login', s_("Title|Change login")
    end

    def change_login_button
      s_('Button|Change login')
    end

    def login_label
      if request.matched_path.match /change-login/
        s_("Label|New email")
      else
        super
      end
    end


    def password_label
      if request.matched_path.match /change-login/
        s_("Label|Current password")
      else
        super
      end
    end


    def change_login(login)
      if account_ds.get(login_column).downcase == login.downcase
        @login_requirement_message = _('same as current login')
        return false
      end

      update_login(login)
    end

    # private

    # def update_login(login)
    #   updated = nil
    #   raised = raises_uniqueness_violation?{updated = update_account({login_column=>login}, account_ds.exclude(login_column=>login)) == 1}
    #   if raised
    #     @login_requirement_message = _('already an account with this login')
    #   end
    #   updated && !raised
    # end



  end
end
