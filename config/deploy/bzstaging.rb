set :default_env, { 'RAILS_ENV' => 'bzstaging' }
set :rails_env, 'bzstaging'
set :branch, ENV["BRANCH"] || 'master'

server '54.171.61.215', user: 'qae', roles: %w{web app db bzstaging}
