set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '54.77.25.71', user: 'qae', roles: %w{web app db}
server '52.18.26.80', user: 'qae', roles: %w{web app db}
