class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  belongs_to :merchant
  belongs_to :customer
  has_many :items, through: :invoice_items

  validates_presence_of :status
end
