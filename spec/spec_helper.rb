RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.disable_monkey_patching!

  config.warnings = false

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.before(:suite) do
    ActiveRecord::Base.transaction do
      FactoryGirl.lint
      raise ActiveRecord::Rollback
    end
    Rails.application.load_seed
  end
end

def build_attributes_for(*args)
  build_object = FactoryGirl.build(*args)
  build_object.attributes.slice(*build_object.class.accessible_attributes).symbolize_keys
end