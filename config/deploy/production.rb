set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.25.12', user: 'qae', roles: %w{web app}
server '52.16.27.191', user: 'qae', roles: %w{web app}
