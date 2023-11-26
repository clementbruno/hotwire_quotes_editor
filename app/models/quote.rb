class Quote < ApplicationRecord
  validates :name, presence: true
  
  scope :ordered, -> { order(id: :desc) }

  has_many :line_item_dates, dependent: :destroy
  has_many :line_items, through: :line_item_dates

  # after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }
  # after_update_commit -> { broadcast_replace_to("quotes", partial: "quotes/quote", locals: { quote: self }, target: self) }
  
  # Same as:
  # after_create_commit -> { broadcast_prepend_to "quotes" }
  # after_update_commit -> { broadcast_replace_to "quotes" }
  # after_destroy_commit -> { broadcast_remove_to "quotes" }
  
  # Async version:
  # after_create_commit -> { broadcast_prepend_later_to "quotes" }
  # after_update_commit -> { broadcast_replace_later_to "quotes" }
  # after_destroy_commit -> { broadcast_remove_to "quotes" }

  # Same as:
  broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: :prepend

  belongs_to :company

  def total_price
    line_items.sum(&:total_price)
  end
end
