require "test_helper"

class FindableTest < ActiveSupport::TestCase
  FoundItem::TRACKABLE_TYPES.each_value do |klass|
    test "#{klass.name} includes Findable" do
      assert klass.new.respond_to?(:found_items)
    end
  end
end
