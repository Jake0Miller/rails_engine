require 'rails_helper'

describe 'Invoice_items API' do
  it 'sends a list of invoice_items' do
    create_list(:invoice_item, 3)

    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)["data"]

    expect(invoice_items.length).to eq(3)
  end

  it 'can get one invoice_item by its id' do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    invoice_item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(invoice_item["id"].to_i).to eq(id)
  end

  describe 'lookups' do
    before :each do
      @invoice = create(:invoice)
      @item = create(:item)
      @invoice_item_1 = InvoiceItem.create(invoice: @invoice, item: @item, status: 'shipped', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      @invoice_item_2 = InvoiceItem.create(invoice: @invoice, item: @item, status: 'unshipped', created_at: "2013-03-25 09:54:09 UTC", updated_at: "2013-03-25 09:54:09 UTC")
    end

    it 'can get find one invoice_item by search params' do
      get "/api/v1/invoice_items/find?id=#{@invoice_item_2.id}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)
      expect(invoice_item["attributes"]["status"]).to eq(@invoice_item_2.status)

      get "/api/v1/invoice_items/find?status=#{@invoice_item_2.status}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)
      expect(invoice_item["attributes"]["status"]).to eq(@invoice_item_2.status)

      get "/api/v1/invoice_items/find?created_at=#{@invoice_item_2.created_at}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)
      expect(invoice_item["attributes"]["status"]).to eq(@invoice_item_2.status)

      get "/api/v1/invoice_items/find?updated_at=#{@invoice_item_2.updated_at}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)
      expect(invoice_item["attributes"]["status"]).to eq(@invoice_item_2.status)
    end

    it 'can get find multiple invoice_items by search params' do
      get "/api/v1/invoice_items/find_all?name=#{@invoice_item_2.merchant_id}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items.length).to eq(2)
      expect(invoice_items[0]["id"].to_i).to eq(@invoice_item_1.id)
      expect(invoice_items[0]["attributes"]["status"]).to eq(@invoice_item_1.status)
      expect(invoice_items[1]["id"].to_i).to eq(@invoice_item_2.id)
      expect(invoice_items[1]["attributes"]["status"]).to eq(@invoice_item_2.status)
    end

    it 'can get a random invoice_item' do
      get "/api/v1/invoice_items/random"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([@invoice_item_1.id, @invoice_item_2.id]).to include(invoice_item["id"].to_i)
      expect([@invoice_item_1.status, @invoice_item_2.status]).to include(invoice_item["attributes"]["status"])
    end
  end
end
