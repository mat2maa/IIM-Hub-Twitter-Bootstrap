require 'test_helper'

class AirlineTest < ActiveSupport::TestCase
  
  should_require_attributes :name, :code
  should_require_unique_attributes :name, :code
  
end
