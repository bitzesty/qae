require 'capistrano/rails/migrations'

# config valid only for Capistrano 3.2.1 =)
lock '3.2.1'

set :application, 'qae'
set :user, 'qae'
set :repo_url, 'git@github.com:bitzesty/qae.git'

set :slack_team, "bitzesty"
set :slack_token, "7uY0wzrA6uBDBgN8YtSDpASb"
set :slack_icon_emoji,   ->{ ":rocket:" }
set :slack_channel,      ->{ "#qae" }
set :migration_role, 'app'

set :stages, %w(production staging dev demo)
set :default_stage, 'staging'
set :use_sudo, false

if ENV["OLD_SERVERS"]
  set :deploy_to, "/home/qae/application"
else
  set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
end

set :scm, :git

set :webserver, "passenger"

set :rbenv_type, :user
set :rbenv_ruby, '2.1.5'
set :rbenv_roles, :all

set :linked_files, %w(config/database.yml config/secrets.yml .env)
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :whenever_command, "bundle exec whenever"

set :ssh_options, {
  forward_agent: true
}

set :keep_releases, 5

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

  after "deploy:updated",  "whenever:update_crontab"
  after "deploy:reverted", "whenever:update_crontab"
end

# Invoke any rake task via capistrano
# Examples:
#   cap staging cap_rake:invoke task="school:regenerate_letters school_id=1"
namespace :cap_rake do
  desc "Invoke rake task"
  task :invoke, roles: :backend do
    run "cd #{current_path} && bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}"
  end
end


