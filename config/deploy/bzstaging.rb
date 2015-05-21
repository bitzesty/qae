set :default_env, { 'RAILS_ENV' => 'bzstaging' }
set :rails_env, 'bzstaging'
set :branch, ENV["BRANCH"] || 'master'

server '95.138.174.143', user: 'qae', roles: %w{web app db}
