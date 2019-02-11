begin
  case ENV['RACK_ENV'] ||= 'development'
  when 'production'
  when 'development'
    require 'dotenv'
    Dotenv.load(".env.dev")
  when 'test'
    require 'dotenv'
    Dotenv.load(".env.test")
  else
    raise "Unknown environment #{ENV['RACK_ENV'].inspect}"
  end
rescue LoadError
end

require 'sequel/core'

DB = Sequel.sqlite
DB.extension(:connection_validator)
DB.pool.connection_validation_timeout = -1 # always validating (at cost)



Sequel.extension :migration
Sequel::Migrator.run(DB, File.expand_path('../migrate', __FILE__))
