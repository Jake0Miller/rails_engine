require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)["data"]

    expect(merchants.length).to eq(3)
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(merchant["id"].to_i).to eq(id)
  end

  it 'can get a list of items for the merchant' do
    merch_id = create(:merchant).id
    items = create_list(:item, 3)
    items.each {|item| item.update_attributes(merchant_id: merch_id)}
    create(:item)

    get "/api/v1/merchants/#{merch_id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body)["data"]

    expect(items.length).to eq(3)
    expect(Item.all.length).to eq(4)
  end

  it 'can get a list of invoices for the merchant' do
    merch_id = create(:merchant).id
    invoices = create_list(:invoice, 3)
    invoices.each {|invoice| invoice.update_attributes(merchant_id: merch_id)}
    create(:invoice)

    get "/api/v1/merchants/#{merch_id}/invoices"

    expect(response).to be_successful

    invoices = JSON.parse(response.body)["data"]

    expect(invoices.length).to eq(3)
    expect(Invoice.all.length).to eq(4)
  end

  describe 'lookups' do
    it 'can get find one merchant by search params' do
      alex = Merchant.create!(name: 'Alex', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      josh = Merchant.create!(name: 'Josh', created_at: "2012-03-26 09:54:09 UTC", updated_at: "2012-03-26 09:54:09 UTC")

      get "/api/v1/merchants/find?id=#{josh.id}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(josh.id)
      expect(merchant["attributes"]["name"]).to eq(josh.name)

      get "/api/v1/merchants/find?name=Josh"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(josh.id)
      expect(merchant["attributes"]["name"]).to eq(josh.name)

      get "/api/v1/merchants/find?created_at=#{josh.created_at}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(josh.id)
      expect(merchant["attributes"]["name"]).to eq(josh.name)

      get "/api/v1/merchants/find?updated_at=#{josh.updated_at}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(josh.id)
      expect(merchant["attributes"]["name"]).to eq(josh.name)
    end

    it 'can get find multiple merchants by search params' do
      josh_1 = Merchant.create!(name: 'Josh')
      josh_2 = Merchant.create!(name: 'Josh')

      get "/api/v1/merchants/find_all?name=Josh"

      merchants = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchants.length).to eq(2)
      expect(merchants[0]["id"].to_i).to eq(josh_1.id)
      expect(merchants[0]["attributes"]["name"]).to eq(josh_1.name)
      expect(merchants[1]["id"].to_i).to eq(josh_2.id)
      expect(merchants[1]["attributes"]["name"]).to eq(josh_2.name)
    end

    it 'can get a random merchant' do
      josh = Merchant.create!(name: 'Josh')
      alex = Merchant.create!(name: 'Alex')

      get "/api/v1/merchants/random"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([josh.id, alex.id]).to include(merchant["id"].to_i)
      expect([josh.name, alex.name]).to include(merchant["attributes"]["name"])
    end
  end
end
