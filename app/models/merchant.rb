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
end

# "2012-03-27".to_date.all_day
