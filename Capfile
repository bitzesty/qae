require 'capistrano/setup'

require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/rails'
require 'capistrano/sidekiq'
require 'whenever/capistrano'
require 'slackistrano'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
