# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'mail'
gem 'puma'
gem 'sass'                      # depreciated, but sassc gives errors
#gem 'sassc'
# gem 'opal'
# gem 'opal-sprockets'
gem 'tilt'#, '>= 2.0.6'
gem 'erubi'#, '>= 1.5'
gem 'roda'#, '>= 3.13'
gem 'refrigerator'#, '>= 1'
gem 'sequel'#, '>= 5'
gem 'rack-unreloader'
#gem "mysql2"
gem 'sqlite3'
gem "fast_gettext"

gem "rodauth"
gem "bcrypt"

#gem "kan"                    # authorization

group :development do
  gem "rerun"
  gem "ansi"
  gem "gettext"
  gem 'sequel-annotate'
  gem 'closure-compiler'
  gem 'yuicompressor'
  gem 'filewatcher'
end

group :development, :test do
  gem "dotenv"
end

group :test do
  gem 'minitest', '>= 5.7.0'
  gem 'minitest-hooks', '>= 1.1.0'
end
