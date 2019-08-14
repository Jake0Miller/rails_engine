class Transaction < ApplicationRecord
  belongs_to :invoice
  validates_presence_of :credit_card_number, :result

  scope(:successful, -> { where(result: "success") })
end
