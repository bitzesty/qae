set :default_env, { 'RAILS_ENV' => 'bzstaging' }
set :rails_env, 'bzstaging'
set :branch, ENV["BRANCH"] || 'master'

server '54.72.209.147', user: 'qae', roles: %w{web app db bzstaging}
