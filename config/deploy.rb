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

set :stages, %w(production staging)
set :default_stage, 'staging'
set :use_sudo, false

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

set :scm, :git

set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'
set :rbenv_roles, :all

set :linked_files, %w(config/database.yml config/secrets.yml .env)
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :ssh_options, {
  forward_agent: true
}

set :keep_releases, 5

namespace :deploy do
  after :finishing, 'deploy:cleanup'

  after "deploy:updated",  "whenever:update_crontab"
  after "deploy:reverted", "whenever:update_crontab"

  desc 'Invoke a rake command on the remote server'
  task :invoke, [:command] => 'deploy:set_rails_env' do |task, args|
    on primary(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          rake args[:command]
        end
      end
    end
  end
end
