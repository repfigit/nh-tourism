threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

# Bind to all interfaces for Fly.io
bind "0.0.0.0:#{ENV.fetch('PORT', 3000)}"

plugin :tmp_restart

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Preload app for better performance
preload_app!

# Handle worker processes
before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
