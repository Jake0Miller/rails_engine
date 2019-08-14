class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates_presence_of :quantity, :unit_price

  before_save :convert_price_string

  private

  def convert_price_string
    self.unit_price = (self.unit_price.to_f/100).to_s
  end
end
