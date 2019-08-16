class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :merchant_id

  attribute :unit_price do |obj|
    sprintf('%.2f', obj.unit_price.to_f/100)
  end
end
