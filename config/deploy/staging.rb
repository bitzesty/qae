set :default_env, { 'RAILS_ENV' => 'production' }
set :rails_env, 'production'

server '95.138.174.112', user: 'qae', roles: %w{web app}, my_property: :my_value
