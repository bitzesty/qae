set :default_env, { 'RAILS_ENV' => 'staging' }
set :rails_env, 'staging'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.139.74', user: 'qae', roles: %w{web app}
server '52.17.143.230', user: 'qae', roles: %w{web app}
