require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of customers' do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)["data"]

    expect(customers.length).to eq(3)
  end

  it 'can get one customer by its id' do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(customer["id"].to_i).to eq(id)
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

  it 'can get a list of invoices for the customer' do
    cust_id = create(:customer).id
    invoices = create_list(:invoice, 3)
    invoices.each {|invoice| invoice.update_attributes(customer_id: cust_id)}
    create(:invoice)

    get "/api/v1/customers/#{cust_id}/invoices"

    expect(response).to be_successful

    invoices = JSON.parse(response.body)["data"]

    expect(invoices.length).to eq(3)
    expect(Invoice.all.length).to eq(4)
  end

  it 'can get a list of transactions for the customer' do
    cust_id = create(:customer).id
    invoice = create(:invoice)
    invoice.update_attributes(customer_id: cust_id)
    transactions = create_list(:transaction, 3)
    transactions.each {|transaction| transaction.update_attributes(invoice_id: invoice.id)}
    create(:transaction)

    get "/api/v1/customers/#{cust_id}/transactions"

    expect(response).to be_successful

    trans = JSON.parse(response.body)["data"]

    expect(Transaction.all.length).to eq(4)
    expect(trans.length).to eq(3)
  end

  describe 'lookups' do
    before :each do
      @bob = Customer.create!(first_name: 'Bob', last_name: 'Saget', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      @rob = Customer.create!(first_name: 'Rob', last_name: 'Savage', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
    end

    it 'can get find one customer by search params' do
      get "/api/v1/customers/find?id=#{@bob.id}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(@bob.id)
      expect(customer["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(customer["attributes"]["last_name"]).to eq(@bob.last_name)

      get "/api/v1/customers/find?first_name=#{@bob.first_name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(@bob.id)
      expect(customer["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(customer["attributes"]["last_name"]).to eq(@bob.last_name)

      get "/api/v1/customers/find?last_name=#{@bob.last_name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(@bob.id)
      expect(customer["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(customer["attributes"]["last_name"]).to eq(@bob.last_name)

      get "/api/v1/customers/find?created_at=#{@bob.created_at}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(@bob.id)
      expect(customer["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(customer["attributes"]["last_name"]).to eq(@bob.last_name)

      get "/api/v1/customers/find?updated_at=#{@bob.updated_at}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(@bob.id)
      expect(customer["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(customer["attributes"]["last_name"]).to eq(@bob.last_name)
    end

    it 'can get find multiple customers by search params' do
      get "/api/v1/customers/find_all?name=#{@bob.created_at}"

      customers = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customers.length).to eq(2)
      expect(customers[0]["id"].to_i).to eq(@bob.id)
      expect(customers[0]["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(customers[1]["id"].to_i).to eq(@rob.id)
      expect(customers[1]["attributes"]["first_name"]).to eq(@rob.first_name)
    end

    it 'can get a random customer' do
      get "/api/v1/customers/random"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([@bob.id, @rob.id]).to include(customer["id"].to_i)
      expect([@bob.first_name, @rob.first_name]).to include(customer["attributes"]["first_name"])
    end
  end

  describe 'business intel' do
    it 'can get a customers favorite merchant' do
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

      get "/api/v1/customers/#{customer.id}/favorite_merchant"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(merchant_3.id)
    end
  end
end
