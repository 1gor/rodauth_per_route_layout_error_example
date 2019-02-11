dev = ENV['RACK_ENV'] == 'development'

if dev
  require 'logger'
  logger = Logger.new($stdout)
end

module MyApp;end;

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(subclasses: %w'MyApp', logger: logger, reload: dev){MyApp::App}
Unreloader.require('app.rb'){'MyApp::App'}

run(dev ? Unreloader : MyApp::App.freeze.app)

unless dev
  begin
    require 'refrigerator'
  rescue LoadError
  else
    Refrigerator.freeze_core
  end
end
