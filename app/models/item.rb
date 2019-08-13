class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price

  def self.most_sold(num)
    self.joins(:invoice_items)
        .select('items.*, sum(invoice_items.quantity) AS qty')
        .group('items.id')
        .order('qty DESC')
        .limit(num)
  end
end
