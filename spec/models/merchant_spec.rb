require 'rails_helper'

RSpec.describe Merchant do
  describe 'Relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
  end

  describe 'Methods' do
    before :each do
      @josh = Merchant.create!(name: 'Josh')
      @alex = Merchant.create!(name: 'Alex')
    end

    it '.random' do
      merchant = Merchant.random

      expect([@josh.id, @alex.id]).to include(merchant.id)
      expect([@josh.name, @alex.name]).to include(merchant.name)
    end

    it '.merchant_on_invoice' do
      invoice = create(:invoice)
      invoice.update_attributes(merchant_id: @josh.id)
      expect(Merchant.merchant_on_invoice(invoice.id)[0].name).to eq(@josh.name)
      expect(Merchant.merchant_on_invoice(invoice.id)[0].id).to eq(@josh.id)
    end

    it '.merchant_on_item' do
      item = create(:item)
      item.update_attributes(merchant_id: @josh.id)
      expect(Merchant.merchant_on_item(item.id)[0].name).to eq(@josh.name)
      expect(Merchant.merchant_on_item(item.id)[0].id).to eq(@josh.id)
    end

    it '.fav_for_customer' do
      customer = create(:customer)
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      merchant_4 = create(:merchant)
      item_1 = merchant_1.items.create!(name: 'Banana', description: 'Yellow', unit_price: '100')
      item_2 = merchant_2.items.create!(name: 'Apple', description: 'Red', unit_price: '150')
      item_3 = merchant_3.items.create!(name: 'Orange', description: 'Orange', unit_price: '160')
      item_4 = merchant_4.items.create!(name: 'Kiwi', description: 'Green', unit_price: '200')
      invoice_1 = create(:invoice)
      invoice_1.update_attributes(merchant: merchant_1)
      invoice_1.update_attributes(customer: customer)
      invoice_2 = create(:invoice)
      invoice_2.update_attributes(merchant: merchant_2)
      invoice_2.update_attributes(customer: customer)
      invoice_3 = create(:invoice)
      invoice_3.update_attributes(merchant: merchant_3)
      invoice_3.update_attributes(customer: customer)
      invoice_4 = create(:invoice)
      invoice_4.update_attributes(merchant: merchant_4)
      invoice_4.update_attributes(customer: customer)
      transaction_1 = create(:transaction)
      transaction_1.update_attributes(invoice: invoice_1)
      transaction_2 = create(:transaction)
      transaction_2.update_attributes(invoice: invoice_2)
      transaction_3 = create(:transaction)
      transaction_3.update_attributes(invoice: invoice_3)
      transaction_4 = create(:transaction)
      transaction_4.update_attributes(invoice: invoice_3)
      transaction_5 = create(:transaction)
      transaction_5.update_attributes(invoice: invoice_4)

      expect(Merchant.fav_for_customer(customer.id)[0].id).to eq(merchant_3.id)
    end

    describe 'top merchants' do
      before :each do
        @customer = create(:customer)
        @merchant_1 = create(:merchant)
        @invoice_1 = Invoice.create!(status: 'shipped', merchant: @merchant_1, customer: @customer, created_at: "2012-03-25 09:54:09 UTC")
        @item_1 = @merchant_1.items.create!(name: 'Banana', description: 'Yellow', unit_price: '100')
        @invoice_1.invoice_items.create!(item: @item_1, quantity: 500, unit_price: @item_1.unit_price)
        @invoice_1.transactions.create!(credit_card_number: '2468', result: 'success', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
        @merchant_2 = create(:merchant)
        @invoice_2 = Invoice.create!(status: 'shipped', merchant: @merchant_2, customer: @customer, created_at: "2012-03-25 09:54:09 UTC")
        @item_2 = @merchant_2.items.create!(name: 'Banana', description: 'Yellow', unit_price: '100')
        @invoice_2.invoice_items.create!(item: @item_2, quantity: 100, unit_price: @item_2.unit_price)
        @invoice_2.transactions.create!(credit_card_number: '2468', result: 'success', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
        @merchant_3 = create(:merchant)
        @invoice_3 = Invoice.create!(status: 'shipped', merchant: @merchant_3, customer: @customer, created_at: "2012-03-25 09:54:09 UTC")
        @item_3 = @merchant_3.items.create!(name: 'Banana', description: 'Yellow', unit_price: '100')
        @invoice_3.invoice_items.create!(item: @item_3, quantity: 300, unit_price: @item_3.unit_price)
        @invoice_3.transactions.create!(credit_card_number: '2468', result: 'success', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
        @merchant_4 = create(:merchant)
        @invoice_4 = Invoice.create!(status: 'shipped', merchant: @merchant_4, customer: @customer, created_at: "2012-03-25 09:54:09 UTC")
        @item_4 = @merchant_4.items.create!(name: 'Banana', description: 'Yellow', unit_price: '100')
        @invoice_4.invoice_items.create!(item: @item_4, quantity: 30, unit_price: @item_4.unit_price)
        @invoice_4.transactions.create!(credit_card_number: '2468', result: 'success', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      end

      it 'can get the top x merchants by number of items sold' do
        merchant = Merchant.most_sold(3)

        expect(merchant.length).to eq(3)
        expect(merchant[0]["id"].to_i).to eq(@merchant_1.id)
        expect(merchant[1]["id"].to_i).to eq(@merchant_3.id)
        expect(merchant[2]["id"].to_i).to eq(@merchant_2.id)
      end
    end
  end
end
