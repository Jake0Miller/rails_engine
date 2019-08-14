class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  validates_presence_of :name

  def self.merchant_on_invoice(inv_id)
    joins(:invoices)
      .where(invoices: {id: inv_id})
  end
end
