require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  test "#total_price returns the product of the unit price multiplied by the quantity" do
    line_item = line_items(:catering_today)
    assert_equal 250, line_item.total_price
  end
end
