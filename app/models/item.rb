class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates_presence_of :name, :description, :unit_price

  scope(:order_by_id, -> { order(id: :asc) })

  def self.most_sold(limit)
    joins(:invoice_items)
        .select('items.*, sum(invoice_items.quantity) AS qty')
        .group('items.id')
        .order('qty DESC')
        .limit(limit)
  end

  def self.most_revenue(limit)
    joins(:invoice_items)
        .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total')
        .group('items.id')
        .order('total DESC')
        .limit(limit)
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
end
