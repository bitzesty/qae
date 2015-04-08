set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.130.34', user: 'qae', roles: %w{web app}
server '52.16.209.16', user: 'qae', roles: %w{web app}
