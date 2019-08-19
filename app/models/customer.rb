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

  def self.pending_invoices(merch_id)
    pending = Customer.joins(invoices: :transactions)
            .where(invoices: {merchant_id: merch_id})
            .having("sum((transactions.result = 'success')::int) = 0")
            .group(['customers.id, invoices.id'])
            .pluck(:id)

    empty = Customer.left_outer_joins(invoices: :transactions)
            .where(invoices: {merchant_id: merch_id})
            .where(transactions: {id: nil})
            .pluck(:id)

    Customer.where(id: pending + empty)
  end
end
