
dev = ENV['RACK_ENV'] == 'development'

if dev
  require 'logger'
  logger = Logger.new($stdout)
end

module MyApp;end;

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(subclasses: %w'Rodauth Rodauth::FeatureConfiguration MyApp Roda Sequel::Model FastGettext Feature', logger: logger, reload: dev){MyApp::App}
require_relative 'models'
Unreloader.require('app.rb'){'MyApp::App'}

if dev
  require 'filewatcher'
  filewatcher = Filewatcher.new(['lib/rodauth/**/*.str','locale/**/*.po'])
  thread = Thread.new(filewatcher) { |fw| fw.watch{ |f| FileUtils.touch './app.rb'}
#  thread = Thread.new(filewatcher) { |fw| fw.watch{ |f| FileUtils.touch './config.ru' }
  }
end

run(dev ? Unreloader : MyApp::App.freeze.app)

unless dev
  begin
    require 'refrigerator'
  rescue LoadError
  else
    require 'sassc' unless File.exist?(File.expand_path('../.compiled_assets.json', __FILE__))
    Refrigerator.freeze_core
  end
end
