set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.21.249', user: 'qae', roles: %w{web app}
server '52.17.46.60', user: 'qae', roles: %w{web app}
