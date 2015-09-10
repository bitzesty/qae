set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'production'

# HARDCODED FOR NOW
server '52.18.126.123', user: 'qae', roles: %w{web app db}
server '52.19.230.94', user: 'qae', roles: %w{web app db}
