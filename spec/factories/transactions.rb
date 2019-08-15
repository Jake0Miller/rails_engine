FactoryBot.define do
  factory :transaction do
    credit_card_number { 1 }
    result { "success" }
    invoice
  end
end
