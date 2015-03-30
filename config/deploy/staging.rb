set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.133.157', user: 'qae', roles: %w{web app}
server '52.17.133.151', user: 'qae', roles: %w{web app}
