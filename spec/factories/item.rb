FactoryBot.define do
  factory :item do
    name { "Banana" }
    description { "Yellow and slippery" }
    unit_price { "100" }
    merchant
  end
end
