RSpec.configure do |config|
  config.before(:suite) do
    # Disable foreign key checks for test environment
    if Rails.env.test?
      ActiveRecord::Base.connection.execute("SET session_replication_role = replica;")
    end

    # Clean database at start with truncation
    DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata])
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    # Re-enable foreign key checks
    if Rails.env.test?
      ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT;")
    end
  end
end
