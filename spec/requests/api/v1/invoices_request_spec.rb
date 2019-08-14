require 'rails_helper'

describe 'Invoices API' do
  before :each do
    @merchant = create(:merchant)
    @customer = create(:customer)
  end

  it 'sends a list of invoices' do
    create_list(:invoice, 3, merchant: @merchant, customer: @customer)

    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)["data"]

    expect(invoices.length).to eq(3)
  end

  it 'can get one invoice by its id' do
    id = create(:invoice, merchant: @merchant, customer: @customer).id

    get "/api/v1/invoices/#{id}"

    invoice = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice["id"].to_i).to eq(id)
  end

  describe 'lookups' do
    before :each do
      @invoice = create(:invoice)
    end

    it 'can get find one invoice by search params' do
      get "/api/v1/invoices/find?id=#{@trans_1.id}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(@trans_1.id)
      expect(invoice["attributes"]["credit_card_number"]).to eq(@trans_1.credit_card_number)
      expect(invoice["attributes"]["result"]).to eq(@trans_1.result)

      get "/api/v1/invoices/find?credit_card_number=#{@trans_1.credit_card_number}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(@trans_1.id)
      expect(invoice["attributes"]["credit_card_number"]).to eq(@trans_1.credit_card_number)
      expect(invoice["attributes"]["result"]).to eq(@trans_1.result)

      get "/api/v1/invoices/find?created_at=#{@trans_2.created_at}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(@trans_2.id)
      expect(invoice["attributes"]["credit_card_number"]).to eq(@trans_2.credit_card_number)
      expect(invoice["attributes"]["result"]).to eq(@trans_2.result)

      get "/api/v1/invoices/find?updated_at=#{@trans_2.updated_at}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(@trans_2.id)
      expect(invoice["attributes"]["credit_card_number"]).to eq(@trans_2.credit_card_number)
      expect(invoice["attributes"]["result"]).to eq(@trans_2.result)
    end

    it 'can get find multiple invoices by search params' do
      get "/api/v1/invoices/find_all?name=#{@trans_1.created_at}"

      invoices = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoices.length).to eq(2)
      expect(invoices[1]["id"].to_i).to eq(@trans_1.id)
      expect(invoices[1]["attributes"]["credit_card_number"]).to eq(@trans_1.credit_card_number)
      expect(invoices[0]["id"].to_i).to eq(@trans_2.id)
      expect(invoices[0]["attributes"]["credit_card_number"]).to eq(@trans_2.credit_card_number)
    end

    it 'can get a random invoice' do
      get "/api/v1/invoices/random"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([@trans_1.id, @trans_2.id]).to include(invoice["id"].to_i)
      expect([@trans_1.credit_card_number, @trans_2.credit_card_number]).to include(invoice["attributes"]["credit_card_number"])
    end
  end
end
