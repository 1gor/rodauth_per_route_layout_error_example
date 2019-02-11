require 'rubygems'
require 'fast_gettext'

FastGettext.add_text_domain('app', path: 'locale', type: :po)
FastGettext.add_text_domain('config', path: 'locale', type: :yaml)
FastGettext.text_domain = 'app'
FastGettext.default_text_domain = 'app'
FastGettext.available_locales = ['en','ru'] # only allow these locales to be set (optional)
FastGettext.locale = ENV['MYAPP_LOCALE'] || 'ru'

class MyApp::App

  # Translation
  include FastGettext::Translation
  include FastGettext::TranslationMultidomain
  extend FastGettext::Translation
  extend FastGettext::TranslationMultidomain

end
