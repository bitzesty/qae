namespace :cf do
  desc "We should run migrations on the first application instance"
  task :run_migrations do
    instance_index = ENV.fetch("CF_INSTANCE_INDEX", nil)

    exit(0) if instance_index.blank? || !instance_index.to_i.zero?
  end
end
