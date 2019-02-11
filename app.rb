# coding: utf-8
Encoding.default_external = Encoding::UTF_8
require_relative 'models'
require 'roda'
require 'fast_gettext'

# # If using opal
# require 'opal'
# require 'opal-sprockets'
# Opal.append_path File.expand_path('../assets/js', __FILE__)

$LOAD_PATH.unshift(File.dirname(__FILE__),'lib')

module MyApp; end

class MyApp::App < Roda
  opts[:root] = FileUtils.pwd

  Unreloader.require('config'){}
  Unreloader.record_split_class(__FILE__, 'config')

  opts[:locale] = ::FastGettext.locale

  FastGettext.reload! if ENV['RACK_ENV'] == 'development'

  # Libraries
  Dir["./lib/*.rb"].each {|f| require f }

  #Unreloader.require('lib/rodauth'){}

  # Dir["./lib/**/*.rb"].each {|f| require f }


  opts[:site_title]=_('MyAPP Title')


  plugin :default_headers,
         'Content-Type'=>'text/html',
         #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
         'X-Frame-Options'=>'deny',
         'X-Content-Type-Options'=>'nosniff',
         'X-XSS-Protection'=>'1; mode=block'
  plugin :content_security_policy do |csp|
    csp.default_src :none
    csp.img_src :self, 'data:'
    csp.font_src :self, 'data:'
    csp.style_src :self, :unsafe_inline
    csp.form_action :self
    csp.script_src :self,'strict-dynamic', :unsafe_inline, '0.0.0.0'
    csp.connect_src :self
    csp.base_uri :none
    csp.frame_ancestors :none
  end

  plugin :route_csrf
  plugin :flash

  plugin :render, escape: true, layout: 'layouts/default', template_opts: {default_encoding: Encoding::UTF_8}, cache: (ENV['RACK_ENV']!='development'), :allowed_paths=>["views", "views/layouts"]
  plugin :partials
  plugin :content_for
  plugin :public
  plugin :multi_route

  plugin :halt


  plugin :sessions,
    key: '_MyApp.session',
    #cookie_options: {secure: ENV['RACK_ENV'] != 'test'}, # Uncomment if only allowing https:// access
    secret: ENV.send((ENV['RACK_ENV'] == 'development' ? :[] : :delete), 'MYAPP_SESSION_SECRET')

  Unreloader.require('routes'){}
  Unreloader.require('helpers'){}
  Unreloader.require('views'){}
  include Helper

  plugin :path
  path :root, '/'

  route do |r|
    ::FastGettext.locale = opts[:locale]   # need to set locale here! Or puma messes it up.
    r.rodauth
    r.public
    r.assets
    check_csrf!
    r.multi_route

    r.root do
      view 'home/index'
    end
  end

end
