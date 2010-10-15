ENV["RAILS_ENV"] = "test"

# Boot rails application and testing parts ...
require "fixtures/rails_app/config/environment"
require "rails/test_help"

# As we are simulating the application we need to reload the
# configurations to get the custom paths.
Typus.reload!

load File.join(File.dirname(__FILE__), "schema.rb")
require 'factories'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
