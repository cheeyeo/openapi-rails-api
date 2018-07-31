RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:example, :db) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
