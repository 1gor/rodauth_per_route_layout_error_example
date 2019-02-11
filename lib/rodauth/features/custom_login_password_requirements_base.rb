module Rodauth

  # :feature_name will be the argument given to enable to
  # load the feature, :FeatureName is optional and will be used to
  # set a constant name for prettier inspect output.
  Feature.define(:custom_login_password_requirements_base, :CustomLoginPasswordRequirementsBase) do
    include FastGettext::Translation
    extend FastGettext::Translation

    depends :login_password_requirements_base

    auth_value_method :logins_do_not_match_message, _('logins do not match')
    auth_value_method :passwords_do_not_match_message, _('passwords do not match')
    auth_value_method :same_as_existing_password_message, _("invalid password, same as current password")
    auth_value_method :require_login_confirmation?, false
    # test only
    auth_value_method :login_maximum_length, 255
    auth_value_methods(
      :password_does_not_meet_requirements_message,
    )


    def login_confirm_label
      #_("Confirm %s") % login_label.mb_chars.downcase.to_s
      _("Confirm %s") % login_label.downcase.to_s
      #super
    end

    def password_confirm_label
      # see https://stackoverflow.com/a/7378207
      #_("Confirm %s") % password_label.mb_chars.downcase.to_s
      _("Confirm %s") % password_label.downcase.to_s

      #super
    end

    def password_does_not_meet_requirements_message
      str = _("invalid password, does not meet requirements")
      if password_requirement_message
        str =+ password_requirement_message
      end
      str
      #super
      _("invalid password, does not meet requirements%s") % (" (#{password_requirement_message})") if password_requirement_message
    end

    def password_too_short_message
      # _('Hello %{name}!') % {name: "Pete"}
      _("minimum %s characters") % password_minimum_length
      #super
    end

    def login_does_not_meet_requirements_message
      _("invalid login") + (" (#{login_requirement_message})" if login_requirement_message).to_s
    end

    def login_too_long_message
      # _('Hello %{name}!') % {name: "Pete"}
      _("maximum %s characters") % login_maximum_length
      #super
    end

    def login_too_short_message
      # _('Hello %{name}!') % {name: "Pete"}
      _("minimum %s characters") % login_minimum_length
      #super
    end


    def login_meets_email_requirements?(login)
      return true unless require_email_address_logins?
      if login =~ /\A[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+\z/
        return true
      end
      @login_requirement_message = _('not a valid email address')
      return false
    end


    def password_does_not_contain_null_byte?(password)
      return true unless password.include?("\0")
      @password_requirement_message = _('contains null byte')
      false
    end


  end
end
