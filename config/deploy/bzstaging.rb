set :default_env, { 'RAILS_ENV' => 'bzstaging' }
set :rails_env, 'production'
set :branch, ENV["BRANCH"] || 'master'

server '95.138.170.133', user: 'qae', roles: %w{web app db}
