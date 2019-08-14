FactoryBot.define do
  factory :invoice_item do
    quantity { 1 }
    unit_price { 1 }
    invoice
    item
  end
end
