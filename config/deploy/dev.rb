set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'master'

set :shoryuken_default_hooks,  false

server '95.138.174.112', user: 'qae', roles: %w{web app}
