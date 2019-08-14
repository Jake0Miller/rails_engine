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
