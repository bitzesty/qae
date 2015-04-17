set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'master'

# HARDCODED FOR NOW
server '52.17.157.216', user: 'qae', roles: %w{web app db}
server '52.17.165.117', user: 'qae', roles: %w{web app db}
