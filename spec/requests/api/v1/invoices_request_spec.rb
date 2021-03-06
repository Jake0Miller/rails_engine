require 'rails_helper'

describe 'Invoices API' do
  it 'sends a list of invoices' do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)["data"]

    expect(invoices.length).to eq(3)
  end

  it 'can get one invoice by its id' do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice["id"].to_i).to eq(id)
  end

  it 'can get a list of transactions for the invoice' do
    inv_id = create(:invoice).id
    transactions = create_list(:transaction, 3)
    transactions.each {|transaction| transaction.update_attributes(invoice_id: inv_id)}
    create(:transaction)

    get "/api/v1/invoices/#{inv_id}/transactions"

    expect(response).to be_successful

    transactions = JSON.parse(response.body)["data"]

    expect(transactions.length).to eq(3)
    expect(Transaction.all.length).to eq(4)
  end

  it 'can get a list of invoice items for the invoice' do
    inv_id = create(:invoice).id
    inv_items = create_list(:invoice_item, 3)
    inv_items.each {|inv_item| inv_item.update_attributes(invoice_id: inv_id)}
    create(:invoice_item)

    get "/api/v1/invoices/#{inv_id}/invoice_items"

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)["data"]

    expect(invoice_items.length).to eq(3)
    expect(InvoiceItem.all.length).to eq(4)
  end

  it 'can get a list of items for the invoice' do
    inv = create(:invoice)
    items = create_list(:item, 3)
    inv_items = create_list(:invoice_item, 3)
    inv_items.each do |i_item|
      i_item.update_attributes(invoice_id: inv.id)
    end
    create_list(:item, 4)

    get "/api/v1/invoices/#{inv.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body)["data"]

    expect(items.length).to eq(3)
    expect(Item.all.length).to eq(10)
  end

  it 'can get the customer for the invoice' do
    invoice = create(:invoice)
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    invoice.update_attributes(customer_id: customer_2.id)

    get "/api/v1/invoices/#{invoice.id}/customer"

    expect(response).to be_successful

    customer = JSON.parse(response.body)["data"]

    expect(customer["id"].to_i).to eq(customer_2.id)
  end

  it 'can get the merchant for the invoice' do
    invoice = create(:invoice)
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    invoice.update_attributes(merchant_id: merchant_2.id)

    get "/api/v1/invoices/#{invoice.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body)["data"]

    expect(merchant["id"].to_i).to eq(merchant_2.id)
  end

  describe 'lookups' do
    before :each do
      @merchant = Merchant.create(name: 'Bob')
      @customer = Customer.create(first_name: 'Bob', last_name: 'Saget')
      @invoice_1 = Invoice.create(merchant: @merchant, customer: @customer, status: 'shipped', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      @invoice_2 = Invoice.create(merchant: @merchant, customer: @customer, status: 'unshipped', created_at: "2013-03-25 09:54:09 UTC", updated_at: "2013-03-25 09:54:09 UTC")
    end

    it 'can get find one invoice by search params' do
      get "/api/v1/invoices/find?id=#{@invoice_2.id}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(@invoice_2.id)
      expect(invoice["attributes"]["status"]).to eq(@invoice_2.status)

      get "/api/v1/invoices/find?status=#{@invoice_2.status}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(@invoice_2.id)
      expect(invoice["attributes"]["status"]).to eq(@invoice_2.status)

      get "/api/v1/invoices/find?created_at=#{@invoice_2.created_at}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(@invoice_2.id)
      expect(invoice["attributes"]["status"]).to eq(@invoice_2.status)

      get "/api/v1/invoices/find?updated_at=#{@invoice_2.updated_at}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(@invoice_2.id)
      expect(invoice["attributes"]["status"]).to eq(@invoice_2.status)
    end

    it 'can get find multiple invoices by search params' do
      get "/api/v1/invoices/find_all?name=#{@invoice_2.merchant_id}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[0]["id"].to_i).to eq(@invoice_1.id)
      expect(invoices[0]["attributes"]["status"]).to eq(@invoice_1.status)
      expect(invoices[1]["id"].to_i).to eq(@invoice_2.id)
      expect(invoices[1]["attributes"]["status"]).to eq(@invoice_2.status)
    end

    it 'can get a random invoice' do
      get "/api/v1/invoices/random"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([@invoice_1.id, @invoice_2.id]).to include(invoice["id"].to_i)
      expect([@invoice_1.status, @invoice_2.status]).to include(invoice["attributes"]["status"])
    end
  end
end
