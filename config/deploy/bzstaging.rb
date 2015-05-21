set :default_env, { 'RAILS_ENV' => 'bzstaging' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'master'

server '<YOUR IP BRO>', user: 'qae', roles: %w{web app db}
