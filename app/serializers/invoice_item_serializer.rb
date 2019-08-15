class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :quantity, :unit_price, :invoice_id, :item_id

  attribute :unit_price do |obj|
    obj.unit_price.to_s
  end
end
