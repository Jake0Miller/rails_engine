require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)["data"]

    expect(items.length).to eq(3)
  end

  it 'can get one item by its id' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(item["id"].to_i).to eq(id)
  end

  describe 'lookups' do
    before :each do
      @merchant = create(:merchant)
    end

    it 'can get find one item by search params' do
      donkey = @merchant.items.create!(name: 'Donkey', description: "Hee haw!", unit_price: 4_000, created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      monkey = @merchant.items.create!(name: 'Monkey', description: "Ooh ooh!", unit_price: 5_000, created_at: "2012-03-26 09:54:09 UTC", updated_at: "2012-03-26 09:54:09 UTC")

      get "/api/v1/items/find?id=#{monkey.id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(monkey.id)
      expect(item["attributes"]["name"]).to eq(monkey.name)
      expect(item["attributes"]["unit_price"]).to eq(monkey.unit_price)

      get "/api/v1/items/find?name=#{monkey.name}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(monkey.id)
      expect(item["attributes"]["name"]).to eq(monkey.name)

      get "/api/v1/items/find?description=#{monkey.description}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(monkey.id)
      expect(item["attributes"]["name"]).to eq(monkey.name)

      get "/api/v1/items/find?unit_price=#{monkey.unit_price}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(monkey.id)
      expect(item["attributes"]["name"]).to eq(monkey.name)

      get "/api/v1/items/find?created_at=#{monkey.created_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(monkey.id)
      expect(item["attributes"]["name"]).to eq(monkey.name)

      get "/api/v1/items/find?updated_at=#{monkey.updated_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(monkey.id)
      expect(item["attributes"]["name"]).to eq(monkey.name)

      get "/api/v1/items/find?merchant_id=#{monkey.merchant_id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([donkey.id, monkey.id]).to include(item["id"].to_i)
      expect([donkey.name, monkey.name]).to include(item["attributes"]["name"])
    end

    it 'can get find multiple items by search params' do
      monkey_1 = @merchant.items.create!(name: 'Monkey', description: "Ooh ooh!", unit_price: 5_000, created_at: "2012-03-26 09:54:09 UTC", updated_at: "2012-03-26 09:54:09 UTC")
      donkey = @merchant.items.create!(name: 'Donkey', description: "Hee haw!", unit_price: 4_000, created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      monkey_2 = @merchant.items.create!(name: 'Monkey', description: "Ooh ooh!", unit_price: 5_000, created_at: "2012-03-26 09:54:09 UTC", updated_at: "2012-03-26 09:54:09 UTC")

      get "/api/v1/items/find_all?name=Monkey"

      items = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(items.length).to eq(2)
      expect(items[0]["id"].to_i).to eq(monkey_1.id)
      expect(items[0]["attributes"]["name"]).to eq(monkey_1.name)
      expect(items[1]["id"].to_i).to eq(monkey_2.id)
      expect(items[1]["attributes"]["name"]).to eq(monkey_2.name)

      get "/api/v1/items/find_all?merchant_id=#{@merchant.id}"

      items = JSON.parse(response.body)["data"]
      expect(response).to be_successful
      expect(items.length).to eq(3)
    end

    it 'can get a random item' do
      donkey = @merchant.items.create!(name: 'Donkey', description: "Hee haw!", unit_price: 4_000, created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      monkey = @merchant.items.create!(name: 'Monkey', description: "Ooh ooh!", unit_price: 5_000, created_at: "2012-03-26 09:54:09 UTC", updated_at: "2012-03-26 09:54:09 UTC")

      get "/api/v1/items/random"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([donkey.id, monkey.id]).to include(item["id"].to_i)
      expect([donkey.name, monkey.name]).to include(item["attributes"]["name"])
    end
  end

  describe 'business intel' do
    before :each do
      @merchant = create(:merchant)
      @customer = Customer.create!(first_name: 'Bob', last_name: 'Saget')
      @item_1 = @merchant.items.create!(name: 'Banana', description: 'Yellow', unit_price: '100')
      @item_2 = @merchant.items.create!(name: 'Apple', description: 'Red', unit_price: '150')
      @item_3 = @merchant.items.create!(name: 'Orange', description: 'Orange', unit_price: '160')
      @item_4 = @merchant.items.create!(name: 'Kiwi', description: 'Green', unit_price: '200')
      @item_5 = @merchant.items.create!(name: 'Avocado', description: 'Lumpy', unit_price: '400')
      @invoice_1 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-25 09:54:09 UTC")
      @invoice_2 = Invoice.create!(status: 'shipped', merchant: @merchant, customer: @customer, created_at: "2012-03-12 05:54:09 UTC")
      @invoice_item_1 = InvoiceItem.create!(item: @item_1, invoice: @invoice_1, quantity: 5, unit_price: @item_1.unit_price)
      @invoice_item_2 = InvoiceItem.create!(item: @item_2, invoice: @invoice_1, quantity: 2, unit_price: @item_2.unit_price)
      @invoice_item_3 = InvoiceItem.create!(item: @item_3, invoice: @invoice_1, quantity: 1, unit_price: @item_3.unit_price)
      @invoice_item_4 = InvoiceItem.create!(item: @item_4, invoice: @invoice_1, quantity: 3, unit_price: @item_4.unit_price)
      @invoice_item_5 = InvoiceItem.create!(item: @item_4, invoice: @invoice_2, quantity: 3, unit_price: @item_4.unit_price)
      @invoice_item_6 = InvoiceItem.create!(item: @item_5, invoice: @invoice_1, quantity: 3, unit_price: @item_5.unit_price)
    end

    it 'can get the top x items by total number sold' do
      get '/api/v1/items/most_items?quantity=3'

      top_items = JSON.parse(response.body)["data"]

      expect(top_items.length).to eq(3)
      expect(top_items[0]["attributes"]["name"]).to eq(@item_4.name)
      expect(top_items[1]["attributes"]["name"]).to eq(@item_1.name)
      expect(top_items[2]["attributes"]["name"]).to eq(@item_5.name)
    end

    it 'can get the best sales date for an item' do
      get "/api/v1/items/#{@item_4.id}/best_day"

      top_item = JSON.parse(response.body)["data"]

      expect(top_item["id"].to_i).to eq(@item_4.id)
      expect(top_item["attributes"]["name"]).to eq(@item_4.name)
      expect(top_item["attributes"]["qty"]).to eq(@invoice_item_4.quantity)
      expect(top_item["attributes"]["day"]).to eq(@invoice_1.created_at.strftime("%Y-%m-%d"))
    end
  end
end
