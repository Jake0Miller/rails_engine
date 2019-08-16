class Customer < ApplicationRecord
  has_many :invoices
  validates_presence_of :first_name, :last_name

  def self.customer_on_invoice(inv_id)
    joins(:invoices)
      .where(invoices: {id: inv_id})
  end

  def self.favorite_customer(merch_id)
    select('customers.*, COUNT(*) AS total')
      .joins(invoices: [:transactions, :merchant])
      .group(:id)
      .where(invoices: {merchant_id: merch_id})
      .merge(Transaction.successful)
      .order(total: :desc)
      .limit(1)
  end
end
