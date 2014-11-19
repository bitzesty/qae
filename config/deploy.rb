# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'qae'
set :user, 'qae'
set :repo_url, 'git@github.com:bitzesty/qae.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :stages, %w(staging)
set :default_stage, 'staging'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/qae/application"
set :deploy_via, :remote_cache

# Default value for :linked_files is []
set :linked_files, %w(config/database.yml config/secrets.yml)

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :ssh_options, {
  forward_agent: true
}
set :rbenv_ruby, '2.1.5'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :mkdir, "-p", release_path.join('tmp')
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :finishing, 'deploy:cleanup'
  before :finishing, 'deploy:restart'
  after 'deploy:rollback', 'deploy:restart'
end
