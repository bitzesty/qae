set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.205.208', user: 'qae', roles: %w{web app db}
server '52.17.104.57', user: 'qae', roles: %w{web app db}
