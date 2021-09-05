max_threads_count = min_threads_count = 1

threads        max_threads_count, min_threads_count
worker_timeout 3600
port           ENV.fetch("PORT") { 3000 }
environment    ENV.fetch("RAILS_ENV") { "development" }
pidfile        ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
workers        ENV.fetch("WEB_CONCURRENCY") { 1 }

plugin :tmp_restart
