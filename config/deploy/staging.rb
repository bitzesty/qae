set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.212.1', user: 'qae', roles: %w{web app db}
server '52.17.204.106', user: 'qae', roles: %w{web app db}
