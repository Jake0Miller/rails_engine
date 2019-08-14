FactoryBot.define do
  factory :invoice do
    status { "MyString" }
    merchant
    customer
  end
end
