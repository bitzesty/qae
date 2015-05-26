set :default_env, { 'RAILS_ENV' => 'bzstaging' }
set :rails_env, 'bzstaging'
set :branch, ENV["BRANCH"] || 'master'

server '162.13.46.189', user: 'qae', roles: %w{web app db bzstaging}
