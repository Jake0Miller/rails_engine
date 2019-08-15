class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  validates_presence_of :name

  def self.merchant_on_invoice(inv_id)
    joins(:invoices)
      .where(invoices: {id: inv_id})
  end

  def self.merchant_on_item(inv_id)
    joins(:items)
      .where(items: {id: inv_id})
  end

  def self.fav_for_customer(cust_id)
    test = joins(invoices: :transactions)
      .where(invoices: {customer_id: cust_id})
      .merge(Transaction.successful)
      .select('merchants.*, COUNT(*) AS total')
      .group(:id)
      .order(total: :desc)
      .limit(1)
  end

  def self.most_sold(limit)
    joins(invoices: [:transactions, :invoice_items])
      .select('merchants.*, sum(invoice_items.quantity) AS qty')
      .group(:id)
      .merge(Transaction.successful)
      .order(qty: :DESC)
      .limit(limit)
  end

  def self.most_revenue(limit)
    joins(invoices: [:transactions, :invoice_items])
      .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS qty')
      .group(:id)
      .merge(Transaction.successful)
      .order(qty: :DESC)
      .limit(limit)
  end
end

# "2012-03-27".to_date.all_day
