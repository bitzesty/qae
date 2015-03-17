set :default_env, { 'RAILS_ENV' => 'dev' }
set :rails_env, 'dev'
set :branch, 'dev'

set :shoryuken_default_hooks,  false

server '95.138.174.112', user: 'qae', roles: %w{web app}
