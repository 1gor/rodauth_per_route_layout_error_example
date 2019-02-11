# Other

desc "Annotate Sequel models"
task "annotate" do
  ENV['RACK_ENV'] = 'development'
  require_relative 'models'
  DB.loggers.clear
  require 'sequel/annotate'
  Sequel::Annotate.annotate(Dir['models/*.rb'])
end

namespace :assets do

  desc "Precompile the assets"
  task :precompile => :decompile do
    require './app.rb'
    p 'compiling assets...'
    MyApp::App.compile_assets
  end

  desc 'Clear precompiled assets'
  task :decompile do
    sh 'rm -f ./.compiled_assets.json'
    sh 'rm -rf ./public/assets'
  end
end
