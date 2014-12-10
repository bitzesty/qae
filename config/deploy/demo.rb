set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, 'demo'

server '162.13.46.66', user: 'qae', roles: %w{web app}
