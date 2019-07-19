web: bundle exec rake cf:run_migrations db:migrate && bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -L ./log/worker.log -C ./config/sidekiq.yml
