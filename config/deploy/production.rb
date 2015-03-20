set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.16.161.206', user: 'qae', roles: %w{web app}
server '52.17.14.164', user: 'qae', roles: %w{web app}
