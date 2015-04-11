set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.6.96', user: 'qae', roles: %w{web app}
server '52.16.115.121', user: 'qae', roles: %w{web app}
