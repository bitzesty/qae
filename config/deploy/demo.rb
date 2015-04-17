set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'master'

set :shoryuken_default_hooks,  false

server '162.13.46.66', user: 'qae', roles: %w{web app db}
