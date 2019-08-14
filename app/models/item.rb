class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price

  before_save :convert_price_string

  def self.most_sold(num)
    self.joins(:invoice_items)
        .select('items.*, sum(invoice_items.quantity) AS qty')
        .group('items.id')
        .order('qty DESC')
        .limit(num)
  end

  def self.date_of_highset_sales(item_id)
    self.joins(:invoices)
        .where("items.id = #{item_id}")
        .select("items.id, items.name, sum(invoice_items.quantity) AS qty, invoices.created_at::date AS day")
        .group('day')
        .group('items.id')
        .order('qty DESC')
        .order('day DESC')
        .limit(1)
  end

  private

  def convert_price_string
    self.unit_price = (self.unit_price.to_f/100).to_s
  end
end
