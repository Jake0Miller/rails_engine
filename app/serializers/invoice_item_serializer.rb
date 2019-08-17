class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :quantity, :unit_price, :invoice_id, :item_id

  attribute :unit_price do |obj|
    sprintf('%.2f', obj.unit_price.to_f/100)
  end
end
