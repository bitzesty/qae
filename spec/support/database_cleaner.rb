RSpec.configure do |config|
  # config.before(:suite) do
  #   DatabaseCleaner[:active_record].clean_with(:truncation)
  # end
  #
  # config.before(:each) do
  #   DatabaseCleaner[:active_record].strategy = :transaction
  # end
  #
  # config.before(:each, js: true) do
  #   DatabaseCleaner[:active_record].strategy = :truncation
  # end
  #
  # config.before(:each) do
  #   DatabaseCleaner[:active_record].start
  # end
  #
  # config.after(:each) do
  #   DatabaseCleaner[:active_record].clean
  # end

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
