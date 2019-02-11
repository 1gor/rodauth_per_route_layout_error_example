# coding: utf-8
Encoding.default_external = Encoding::UTF_8
require_relative 'db'
require 'roda'
require 'logger'

module MyApp; end

class MyApp::App < Roda

  plugin :view_options
  plugin :flash
  plugin :rodauth, :csrf=>:route_csrf, :flash=>false do

    enable(:login,:logout,:create_account)

    # With reference to news group thread
    # https://groups.google.com/forum/#!topic/rodauth/MOBVSp2z-Qg
    #
    # # UNCOMMENT TO SEE NORMALLY WORKING APP WITH SESSION LAYOUT
    # # This is proposed solution

    # template_opts do
    #   case request.path
    #   when "/login", "/logout"
    #     { layout: "layouts/session" }
    #   else
    #     { }
    #   end
    # end

    # UNCOMMENT THIS TO SEE ERROR
    before_login_route do
      # Giving wrong template name results in "No such file or directory"  error
      #request.scope.set_view_options template: 'sessiossss'

      # But giving correct template name leads to stack error
      request.scope.set_view_options template: 'layouts/session'
    end

  end


  plugin :render, escape: true, layout: 'layouts/default', template_opts: {default_encoding: Encoding::UTF_8}, cache: (ENV['RACK_ENV']!='development'), :allowed_paths=>["views", "views/layouts"]
  plugin :partials
  plugin :sessions,
    key: '_MyApp.session',
    secret: '4c4d0cf58d6e73fd8e112348e6742842a334b58ba028a940a2974adf24539d1c91c1662e'

#ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'MYAPP_SESSION_SECRET')

  Unreloader.require('views'){}

  route do |r|
    r.rodauth
    r.root do
      view 'home/index'
    end
  end

end
