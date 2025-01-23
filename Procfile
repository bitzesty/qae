web: bundle exec rake cf:run_migrations db:migrate && bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -C ./config/sidekiq.yml
