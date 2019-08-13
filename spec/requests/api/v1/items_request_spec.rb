require 'rails_helper'

describe 'Items API' do
  before :each do
    @merchant = create(:merchant)
  end

  it 'sends a list of items' do
    create_list(:item, 3, merchant: @merchant)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)["data"]

    expect(items.length).to eq(3)
  end

  it 'can get one item by its id' do
    id = create(:item, merchant: @merchant).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(item["id"].to_i).to eq(id)
  end

  it 'can get the top x items by total number sold' do
    customer = Customer.create!(first_name: 'Bob', last_name: 'Saget')
    item_1 = @merchant.items.create!(name: 'Banana', description: 'Yellow', unit_price: '100')
    item_2 = @merchant.items.create!(name: 'Apple', description: 'Red', unit_price: '150')
    item_3 = @merchant.items.create!(name: 'Orange', description: 'Orange', unit_price: '160')
    item_4 = @merchant.items.create!(name: 'Kiwi', description: 'Green', unit_price: '200')
    item_5 = @merchant.items.create!(name: 'Avocado', description: 'Lumpy', unit_price: '400')
    invoice = Invoice.create!(status: 'shipped', merchant: @merchant, customer: customer)
    invoice_item_1 = InvoiceItem.create!(item: item_1, invoice: invoice, quantity: 5, unit_price: item_1.unit_price)
    invoice_item_2 = InvoiceItem.create!(item: item_2, invoice: invoice, quantity: 2, unit_price: item_2.unit_price)
    invoice_item_3 = InvoiceItem.create!(item: item_3, invoice: invoice, quantity: 1, unit_price: item_3.unit_price)
    invoice_item_4 = InvoiceItem.create!(item: item_4, invoice: invoice, quantity: 3, unit_price: item_4.unit_price)
    invoice_item_5 = InvoiceItem.create!(item: item_4, invoice: invoice, quantity: 3, unit_price: item_4.unit_price)
    invoice_item_6 = InvoiceItem.create!(item: item_5, invoice: invoice, quantity: 3, unit_price: item_5.unit_price)

    get '/api/v1/items/most_items?quantity=3'

    top_items = JSON.parse(response.body)["data"]

    expect(top_items.length).to eq(3)
    expect(top_items[0]["attributes"]["name"]).to eq(item_4.name)
    expect(top_items[1]["attributes"]["name"]).to eq(item_1.name)
    expect(top_items[2]["attributes"]["name"]).to eq(item_5.name)
  end
end
