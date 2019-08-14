class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  belongs_to :merchant
  belongs_to :customer
  has_many :items, through: :invoice_items

  validates_presence_of :status

  def self.highest_revenue(limit = 5, dir = :DESC)
    select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price::float) AS total')
      .joins(:invoice_items, :transactions)
      .merge(Transaction.successful)
      .group(:id)
      .order(total: dir)
      .limit(limit)
  end
end
