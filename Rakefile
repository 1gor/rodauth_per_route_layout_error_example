# Migrate

migrate = lambda do |env, version|

  require 'dotenv'
  require 'sequel/core'
  case env
  when 'production'
  when 'development'
    Dotenv.load(".env.dev")
  when 'test'
    Dotenv.load(".env.test")
  else
    raise "Unknown environment #{env.inspect}"
  end

  # Create db connection as migration user (named by convention "<app>_password"))
  require 'uri'
  uri = URI(ENV.delete('MYAPP_DATABASE_URL') || ENV.delete('DATABASE_URL'))
  query = URI.decode_www_form(String(uri.query)).to_h
  db_regular_user = query['user']
  query["user"] = query['user']+'_password'
  uri.query = URI.encode_www_form(query)
  db_url = uri.to_s

  require 'sequel/core'
  Sequel.extension :migration
  require 'logger'

  DB=Sequel.connect(db_url)
  DB.loggers << Logger.new($stdout) if DB.loggers.empty?
  Sequel::Migrator.apply(DB, 'migrate', version)
  db_name = DB.opts[:database]

  # Now grant regular app user (by convention <app>) access to each table
  # except account_password_hashes and :account_previous_password_hashes
  DB.tables.each do |t|
    unless t.match(/password_hashes/)
      DB.run "grant all on #{db_name}.#{t} to #{db_regular_user}"
    end
  end

end

desc "Reset database"
task :db_reset, :project do |t,args|
  project = args[:project] || File.basename(FileUtils.pwd)
  user = "'#{project}'@'%'"
  migration_user = "'#{project}_password'@'%'"
  print "resetting database for #{project}\n"
  str = %Q(
     mysql -uroot -psecret -h0.0.0.0 -e "
     drop database if exists #{project}_dev;
     drop database if exists #{project}_test;
     drop user if exists #{project};
     drop user if exists #{project}_password;
     create user #{user} identified by 'secret';
     create user #{migration_user} identified by 'secret';
     create database #{project}_dev;
     create database #{project}_test;
     -- grant all on #{project}_dev.* to #{user};
     -- grant all on #{project}_test.* to #{user};
     grant all on #{project}_dev.* to #{migration_user} with grant option;
     grant all on #{project}_test.* to #{migration_user} with grant option;
"
)
  system str
end

desc "Migrate test database to latest version"
task :test_up do
  migrate.call('test', nil)
end

desc "Migrate test database all the way down"
task :test_down do
  migrate.call('test', 0)
end

desc "Migrate test database all the way down and then back up"
task :test_bounce do
  migrate.call('test', 0)
  Sequel::Migrator.apply(DB, 'migrate')
end

desc "Migrate development database to latest version"
task :dev_up do
  migrate.call('development', nil)
end

desc "Migrate development database to all the way down"
task :dev_down do
  migrate.call('development', 0)
end

desc "Migrate development database all the way down and then back up"
task :dev_bounce do
  migrate.call('development', 0)
  Sequel::Migrator.apply(DB, 'migrate')
end

desc "Migrate production database to latest version"
task :prod_up do
  migrate.call('production', nil)
end

desc "Migrate development database to given version"
task :dev_to, :version do |t,args|
  version = args[:version]
  raise "No version given" if version.nil? || version == ""
  migrate.call('development', version.to_i)
end


# Shell

irb = proc do |env|
  ENV['RACK_ENV'] = env
  trap('INT', "IGNORE")
  dir, base = File.split(FileUtils::RUBY)
  cmd = if base.sub!(/\Aruby/, 'irb')
          File.join(dir, base)
        else
          "#{FileUtils::RUBY} -S irb"
        end
  sh "#{cmd} -r ./models"
end

desc "Open irb shell in test mode"
task :test_irb do
  irb.call('test')
end

desc "Open irb shell in development mode"
task :dev_irb do
  irb.call('development')
end

desc "Open irb shell in production mode"
task :prod_irb do
  irb.call('production')
end

# Specs

spec = proc do |pattern|
  #  sh "#{FileUtils::RUBY} -e 'ARGV.each{|f| require f}' #{pattern}"
  system "#{FileUtils::RUBY} -e 'ARGV.each{|f| require f}' #{pattern}"
end

desc "Run all specs"
task default: [:model_spec, :web_spec]

desc "Run model specs"
task :model_spec do
  spec.call('./spec/model/*_spec.rb')
end

desc "Run web specs"
task :web_spec do
  spec.call('./spec/web/*_spec.rb')
end

Dir["lib/tasks/**/*.rake"].each {|f| load f }
