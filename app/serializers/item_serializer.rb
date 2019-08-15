class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :merchant_id

  attribute :unit_price do |obj|
    (obj.unit_price.to_f/100).round(2).to_s
  end
end
