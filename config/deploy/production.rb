set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'production'

# HARDCODED FOR NOW
server '52.17.14.201', user: 'qae', roles: %w{web app db}
server '52.17.196.87', user: 'qae', roles: %w{web app db}
