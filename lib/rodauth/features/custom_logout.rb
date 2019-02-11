module Rodauth
  Feature.define(:custom_logout, :CustomLogout) do
extend FastGettext::Translation
    include FastGettext::Translation
    depends :logout

    def logout_redirect
      prefix + "/"
    end

    def template_opts
      {:locals=>{
         :logout_prompt=>_("Do you really want to log out?"),
       }
      }
    end

    def logout_notice_flash
      #_("You have been logged out")
    end

    def logout_view
      view 'logout', s_('Title|Logout')
    end

    def logout_button
      s_('Button|Logout')
    end

    def before_logout_route
      redirect '/' unless logged_in?
      scope.instance_variable_set :"@custom_js", %Q(
<script>
var dialog = document.querySelector('dialog');
if (! dialog.showModal) {
dialogPolyfill.registerDialog(dialog);
}
r(function(){
   dialog.showModal();
});
</script>
)

    end


  end
end
