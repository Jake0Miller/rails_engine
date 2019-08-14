require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of transactions' do
    create_list(:transaction, 3)

    get '/api/v1/transactions'

    expect(response).to be_successful

    transactions = JSON.parse(response.body)["data"]

    expect(transactions.length).to eq(3)
  end

  it 'can get one transaction by its id' do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}"

    transaction = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(transaction["id"].to_i).to eq(id)
  end

  describe 'lookups' do
    before :each do
      @bob = Customer.create!(first_name: 'Bob', last_name: 'Saget', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      @rob = Customer.create!(first_name: 'Rob', last_name: 'Savage', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
    end

    it 'can get find one transaction by search params' do
      get "/api/v1/transactions/find?id=#{@bob.id}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@bob.id)
      expect(transaction["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(transaction["attributes"]["last_name"]).to eq(@bob.last_name)

      get "/api/v1/transactions/find?first_name=#{@bob.first_name}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@bob.id)
      expect(transaction["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(transaction["attributes"]["last_name"]).to eq(@bob.last_name)

      get "/api/v1/transactions/find?last_name=#{@bob.last_name}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@bob.id)
      expect(transaction["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(transaction["attributes"]["last_name"]).to eq(@bob.last_name)

      get "/api/v1/transactions/find?created_at=#{@bob.created_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@bob.id)
      expect(transaction["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(transaction["attributes"]["last_name"]).to eq(@bob.last_name)

      get "/api/v1/transactions/find?updated_at=#{@bob.updated_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@bob.id)
      expect(transaction["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(transaction["attributes"]["last_name"]).to eq(@bob.last_name)
    end

    it 'can get find multiple transactions by search params' do
      get "/api/v1/transactions/find_all?name=#{@bob.created_at}"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(2)
      expect(transactions[0]["id"].to_i).to eq(@bob.id)
      expect(transactions[0]["attributes"]["first_name"]).to eq(@bob.first_name)
      expect(transactions[1]["id"].to_i).to eq(@rob.id)
      expect(transactions[1]["attributes"]["first_name"]).to eq(@rob.first_name)
    end

    it 'can get a random transaction' do
      get "/api/v1/transactions/random"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([@bob.id, @rob.id]).to include(transaction["id"].to_i)
      expect([@bob.first_name, @rob.first_name]).to include(transaction["attributes"]["first_name"])
    end
  end
end
