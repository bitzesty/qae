set :default_env, { 'RAILS_ENV' => 'bzstaging' }
set :rails_env, 'bzstaging'
set :branch, ENV["BRANCH"] || 'master'

server '52.17.151.127', user: 'qae', roles: %w{web app db bzstaging}
