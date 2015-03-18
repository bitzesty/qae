set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.16.119.63', user: 'qae', roles: %w{web app}
server '52.16.140.79', user: 'qae', roles: %w{web app}
