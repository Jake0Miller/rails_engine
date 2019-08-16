class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  belongs_to :merchant
  belongs_to :customer
  has_many :items, through: :invoice_items

  validates_presence_of :status

  def self.highest_revenue(limit = 5, dir = :DESC)
    select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total')
      .joins(:invoice_items, :transactions)
      .merge(Transaction.successful)
      .group(:id)
      .order(total: dir)
      .limit(limit)
  end

  def self.invoice_on_invoice_item(inv_id)
    joins(:invoice_items)
      .where(invoice_items: {id: inv_id})
  end

  def self.invoice_on_transaction(inv_id)
    joins(:transactions)
      .where(transactions: {id: inv_id})
  end

  def self.total_revenue_by_date(date)
    joins(:transactions, :invoice_items)
      .select('sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .where(created_at: date.to_date.all_day)
      .merge(Transaction.successful)
  end

  def self.total_revenue(merch_id)
    joins(:transactions, :invoice_items, :merchant)
      .select('sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .where(merchant_id: merch_id)
      .merge(Transaction.successful)
  end

  def self.total_revenue_by_merch_and_date(merch_id, date)
    joins(:transactions, :invoice_items)
      .select('sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .where(created_at: date.to_date.all_day, merchant_id: merch_id)
      .merge(Transaction.successful)
  end
end
