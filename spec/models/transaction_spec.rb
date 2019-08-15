require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'Relationships' do
    it {should belong_to :invoice}
  end

  describe 'Validations' do
    it {should validate_presence_of :credit_card_number}
    it {should validate_presence_of :result}
  end

  describe 'Methods' do
    it '.transactions_for_customer' do
      invoice = create(:invoice)
      customer = Customer.find(invoice.customer_id)
      create(:transaction)
      transactions = create_list(:transaction, 3)
      transactions.each {|trans| trans.update_attributes(invoice: invoice)}

      expect(Transaction.all.length).to eq(4)
      expect(Transaction.transactions_for_customer(customer.id).length).to eq(3)
      expect(Transaction.transactions_for_customer(customer.id)[0].id).to eq(transactions[0].id)
      expect(Transaction.transactions_for_customer(customer.id)[1].id).to eq(transactions[1].id)
      expect(Transaction.transactions_for_customer(customer.id)[2].id).to eq(transactions[2].id)
    end
  end
end
