set :default_env, { 'RAILS_ENV' => 'demo' }
set :rails_env, 'demo'
set :branch, 'demo'

set :shoryuken_default_hooks,  false

server '162.13.46.66', user: 'qae', roles: %w{web app}
