## Before configuring Puma, you should look up the number of CPU cores your server has, change this to match your CPU core count
#workers Integer(ENV['WEB_CONCURRENCY'] || [1, `grep -c processor /proc/cpuinfo`.to_i].max)

# In docker use 1 worker (increase number of docker instances if needed)
workers 1

threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

#preload_app!

rackup DefaultRackup

# HTTP interface
#port 3000
#port 9031

environment ENV['RACK_ENV'] || 'development'

stdout_redirect(stdout = '/dev/stdout', stderr = '/dev/stderr', append = true)

# # First approach
# # before_fork do
# #   DB.disconnect if defined?(DB)
# # end

# require 'logger'
# require 'sequel/core'

# before_fork do
#   if defined?(::Sequel)
#     Logger.new(STDOUT).debug "Sequel exists for before_fork"
#     Thread.current[:sequel_connect_options] = ::Sequel::DATABASES.map do |db|
#       db.disconnect
#       db.opts[:orig_opts]
#     end
#   end
# end
# on_worker_boot do
#   if defined?(::Sequel)
#     Logger.new(STDOUT).debug "Sequel exists for on_worker_boot"
#     Thread.current[:sequel_connect_options].each do |orig_opts|
#       ::Sequel.connect(orig_opts)
#     end
#   end
# end
