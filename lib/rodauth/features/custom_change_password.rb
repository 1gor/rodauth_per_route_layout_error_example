module Rodauth
  Feature.define(:custom_change_password, :CustomChangePassword) do
extend FastGettext::Translation
    include FastGettext::Translation
    depends :change_password, :base

    # auth_value_method :custom_new_password_label, s_('Label|Current password')

    def new_password_label
      super
      s_("Label|New password")
    end

    def change_password_notice_flash
      _('Your password has been changed')
    end

    def change_password_error_flash
      _('There was an error changing your password')
    end

    def change_password_view
      view 'change-password', s_('Title|Change password')
    end

    def change_password_button
      s_('Button|Change password')
    end

    # def template_opts
    #   {:locals=>{
    #      :=>_("Do really you want to log out?")
    #    }
    #   }
    # end

    # =>     auth_value_method :new_password_label, 'New Password'
    def change_password_new_password_label
      'fla '
    end


    def password_label
      if request.matched_path.match /change-password/
        s_("Label|Current password")
      else
        super
      end
    end

    def password_confirm_label
      if request.matched_path.match /change-password/
        s_("Label|Confirm new password")
      else
        super
      end
    end


  end
end
