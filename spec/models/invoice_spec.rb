require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'Relationships' do
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should belong_to :merchant}
    it {should belong_to :customer}
    it {should have_many(:items).through(:invoice_items)}
  end

  describe 'Validations' do
    it {should validate_presence_of :status}
  end

  describe 'Methods' do
    before :each do
      @merchant = create(:merchant)
      @customer = create(:customer)
      @invoice_1 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-25 09:54:09 UTC")
      @invoice_2 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-12 05:54:09 UTC")
      @invoice_3 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-12 05:54:09 UTC")
      @invoice_4 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-12 05:54:09 UTC")
      @invoice_5 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-12 05:54:09 UTC")
      @invoice_6 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-12 05:54:09 UTC")
      @invoice_7 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-12 05:54:09 UTC")
      @invoice_1.transactions.create!(credit_card_number: '1234', result: 'failure')
      @invoice_2.transactions.create!(credit_card_number: '1234', result: 'success')
      @invoice_3.transactions.create!(credit_card_number: '1234', result: 'success')
      @invoice_4.transactions.create!(credit_card_number: '1234', result: 'success')
      @invoice_5.transactions.create!(credit_card_number: '1234', result: 'success')
      @invoice_6.transactions.create!(credit_card_number: '1234', result: 'success')
      @invoice_7.transactions.create!(credit_card_number: '1234', result: 'success')
      @item_1 = @merchant.items.create!(name: 'Banana', description: 'Yellow', unit_price: '100')
      @item_2 = @merchant.items.create!(name: 'Apple', description: 'Red', unit_price: '150')
      @item_3 = @merchant.items.create!(name: 'Orange', description: 'Orange', unit_price: '160')
      @item_4 = @merchant.items.create!(name: 'Kiwi', description: 'Green', unit_price: '200')
      @item_5 = @merchant.items.create!(name: 'Avocado', description: 'Lumpy', unit_price: '400')
      @invoice_item_1 = @invoice_1.invoice_items.create!(item: @item_1, quantity: 5, unit_price: @item_1.unit_price)
      @invoice_item_2 = @invoice_2.invoice_items.create!(item: @item_2, quantity: 2, unit_price: @item_2.unit_price)
      @invoice_item_3 = @invoice_3.invoice_items.create!(item: @item_3, quantity: 1, unit_price: @item_3.unit_price)
      @invoice_item_3b = @invoice_3.invoice_items.create!(item: @item_4, quantity: 1, unit_price: @item_4.unit_price)
      @invoice_item_4 = @invoice_4.invoice_items.create!(item: @item_4, quantity: 3, unit_price: @item_4.unit_price)
      @invoice_item_5 = @invoice_5.invoice_items.create!(item: @item_4, quantity: 3, unit_price: @item_4.unit_price)
      @invoice_item_6 = @invoice_6.invoice_items.create!(item: @item_5, quantity: 3, unit_price: @item_5.unit_price)
      @invoice_item_7 = @invoice_7.invoice_items.create!(item: @item_5, quantity: 4, unit_price: @item_5.unit_price)
    end

    it '.highest_revenue' do
      top_5 = Invoice.highest_revenue
      expect(top_5.length).to eq(5)
      expect(top_5[0]).to eq(@invoice_7)
      expect(top_5[1]).to eq(@invoice_6)
      expect(top_5[2]).to eq(@invoice_4)
      expect(top_5[3]).to eq(@invoice_5)
      expect(top_5[4]).to eq(@invoice_3)
    end

    it '.invoice_on_invoice_item' do
      expect(Invoice.invoice_on_invoice_item(@invoice_item_1.id)[0].id).to eq(@invoice_1.id)
    end

    it '.invoice_on_transaction' do
      transaction = create(:transaction)
      transaction.update_attributes(invoice: @invoice_1)

      expect(Invoice.invoice_on_transaction(transaction.id)[0].id).to eq(@invoice_1.id)
    end
  end
end
