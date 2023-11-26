require "application_system_test_case"

class LineItemsTest < ApplicationSystemTestCase
  include ActionView::Helpers::NumberHelper

  setup do
    login_as users(:accountant)
    @quote      = quotes(:first)
    @line_item_date = line_item_dates(:today)
    @line_item  = line_items(:room_today)
    visit quote_path(@quote)
  end

  test "Creating a new line_item" do
    within id: dom_id(@line_item_date) do
      click_on "Add item"
    end

    fill_in "Name",        with: "New item"
    fill_in "Description", with: "New item description"
    fill_in "Quantity",    with: 1
    fill_in "Unit price",  with: 100
    click_on "Create item"

    assert_text "New item"
    assert_text "New item description"
    assert_text number_to_currency(@quote.total_price)
  end

  test "Updating a line_item" do
    within id: dom_id(@line_item) do
      click_on "Edit"
    end

    fill_in "Name",        with: "Updated item"
    click_on "Update item"

    assert_text "Updated item"
    assert_text number_to_currency(@quote.total_price)
  end

  test "Destroying a line_item" do
    within id: dom_id(@line_item_date) do
      assert_text @line_item.name
    end

    within id: dom_id(@line_item) do
      click_on "Delete"
    end
    
    within id: dom_id(@line_item_date) do
      assert_no_text @line_item.name
    end

    assert_text number_to_currency(@quote.total_price)
  end
end