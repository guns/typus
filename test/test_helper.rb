ENV["RAILS_ENV"] = "test"

# Boot rails application and testing parts ...
require "fixtures/rails_app/config/environment"
require "rails/test_help"
require "tartare"

require "fixtures/rails_app/db/schema"
require "factories"

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
