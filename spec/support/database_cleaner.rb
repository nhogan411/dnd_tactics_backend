RSpec.configure do |config|
  config.before(:suite) do
    # Clean database at start
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Disable foreign key checks for truncation during test cleanup
  config.before(:suite) do
    ActiveRecord::Base.connection.execute("SET session_replication_role = replica;") if Rails.env.test?
  end

  config.after(:suite) do
    ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT;") if Rails.env.test?
  end
end
