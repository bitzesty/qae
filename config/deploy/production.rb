set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.136.135', user: 'qae', roles: %w{web app db}
server '52.17.176.9', user: 'qae', roles: %w{web app db}
