require_relative 'fast_gettext'
class MyApp::App
  plugin :view_options
  plugin :rodauth, :csrf=>:route_csrf, :flash=>false do
    extend FastGettext::Translation

    ACCOUNT_STATUSES= {1=>s_("AccountStatus|Unverified"), 2=>s_("AccountStatus|Verified"), 3=>s_("AccountStatus|Closed")}

    enabled_features = %I(
base
create_account
change_login
change_password
close_account
email_base
lockout
logout
password_grace_period
session_expiration
verify_login_change
login_password_requirements_base
                    )
    custom_features = %I(
custom_base
custom_create_account
custom_change_login
custom_change_password
custom_email_base
custom_login
custom_lockout
custom_login_password_requirements_base
custom_logout
custom_password_grace_period
custom_reset_password
custom_template_path
custom_verify_login_change
)
    features = [
      enabled_features,
      custom_features
    ].flatten
    #Logging.logger.debug features.to_s

    enable(*features)

    title_instance_variable :@page_title
    templates_dirname "templates_custom"
    #templates_dirname "templates_bs4"

    Unreloader.require('lib/rodauth/features'){}
    #Unreloader.record_dependency "./lib/rodauth", "app.rb"



    # With reference to news group thread
    # https://groups.google.com/forum/#!topic/rodauth/MOBVSp2z-Qg
    #
    # Launch application with
    # $ rackup      # development mode
    # or
    # $ ./prod.sh   # production mode
    #
    # To see english site launch
    # $ MYAPP_LOCALE=en rackup



    # # UNCOMMENT TO SEE NORMALLY WORKING APP
    # # This is proposed solution.

    # template_opts do
    #   case request.path
    #   when "/login", "/reset-password-request"
    #     { layout: "layouts/session" }
    #   else
    #     { }
    #   end
    # end

    # UNCOMMENT THIS TO SEE ERROR (DO COMMENT OUT PREVIOUS SECTION)
    # This gives 'stack level too deep (SystemStackError)'

    before_login_route do
      Logger.new(STDOUT).debug request.scope

      # Giving wrong template name results in "No such file or directory"  error
      request.scope.set_view_options template: 'sessiossss'

      # But giving correct template name leads to recursion
      request.scope.set_view_options template: 'layouts/session'

    end


  end
end
