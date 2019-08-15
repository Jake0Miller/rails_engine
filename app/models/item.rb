class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates_presence_of :name, :description, :unit_price

  before_save :convert_price_string

  scope(:order_by_id, -> { order(id: :asc) })

  def self.most_sold(num)
    joins(:invoice_items)
        .select('items.*, sum(invoice_items.quantity) AS qty')
        .group('items.id')
        .order('qty DESC')
        .limit(num)
  end

  def self.date_of_highset_sales(item_id)
    joins(:invoices)
        .where(items: {id: item_id})
        .select('items.id, items.name, sum(invoice_items.quantity) AS qty, invoices.created_at::date AS best_day')
        .group(:best_day)
        .group(:id)
        .order(qty: :DESC)
        .order(best_day: :DESC)
        .limit(1)
  end

  def self.items_on_invoice(inv_id)
    joins(:invoices)
      .where(invoices: {id: inv_id})
  end

  def self.item_on_invoice_item(inv_id)
    joins(:invoice_items)
      .where(invoice_items: {id: inv_id})
  end

  private

  def convert_price_string
    self.unit_price = (self.unit_price.to_f/100).to_s
  end
end
