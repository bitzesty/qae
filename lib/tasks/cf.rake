namespace :cf do
  desc "We should run migrations on the first application instance"
  task :run_migrations do
    instance_index = ENV["CF_INSTANCE_INDEX"]

    exit(0) if !instance_index.present? || !instance_index.to_i.zero?
  end
end
