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

  it 'can get the item for the invoice item' do
    invoice_item = create(:invoice_item)
    item_1 = create(:item)
    item_2 = create(:item)
    invoice_item.update_attributes(item_id: item_2.id)

    get "/api/v1/invoice_items/#{invoice_item.id}/item"

    expect(response).to be_successful

    item = JSON.parse(response.body)["data"]

    expect(item["id"].to_i).to eq(item_2.id)
  end

  it 'can get the invoice for the invoice item' do
    invoice_item = create(:invoice_item)
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    invoice_item.update_attributes(invoice_id: invoice_2.id)

    get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)["data"]

    expect(invoice["id"].to_i).to eq(invoice_2.id)
  end

  describe 'lookups' do
    before :each do
      @invoice = create(:invoice)
      @item_1 = create(:item)
      @item_2 = create(:item)
      @invoice_item_1 = InvoiceItem.create!(invoice: @invoice, item: @item_1, quantity: 5, unit_price: 500, created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      @invoice_item_2 = InvoiceItem.create!(invoice: @invoice, item: @item_2, quantity: 4, unit_price: 600, created_at: "2013-03-25 09:54:09 UTC", updated_at: "2013-03-25 09:54:09 UTC")
    end

    it 'can get find one invoice_item by search params' do
      get "/api/v1/invoice_items/find?id=#{@invoice_item_2.id}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)

      get "/api/v1/invoice_items/find?quantity=#{@invoice_item_2.quantity}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)

      get "/api/v1/invoice_items/find?unit_price=#{sprintf('%.2f', @invoice_item_2.unit_price.to_f/100)}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)

      get "/api/v1/invoice_items/find?invoice_id=#{@invoice_item_2.invoice_id}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([@invoice_item_1.id,@invoice_item_2.id]).to include(invoice_item["id"].to_i)

      get "/api/v1/invoice_items/find?item_id=#{@invoice_item_2.item_id}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)

      get "/api/v1/invoice_items/find?created_at=#{@invoice_item_2.created_at}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)

      get "/api/v1/invoice_items/find?updated_at=#{@invoice_item_2.updated_at}"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_item["id"].to_i).to eq(@invoice_item_2.id)
    end

    it 'can get find multiple invoice_items by search params' do
      get "/api/v1/invoice_items/find_all?name=#{@invoice_item_2.item_id}"

      invoice_items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice_items.length).to eq(2)
      expect(invoice_items[0]["id"].to_i).to eq(@invoice_item_1.id)
      expect(invoice_items[1]["id"].to_i).to eq(@invoice_item_2.id)
    end

    it 'can get a random invoice_item' do
      get "/api/v1/invoice_items/random"

      invoice_item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([@invoice_item_1.id, @invoice_item_2.id]).to include(invoice_item["id"].to_i)
    end
  end
end
