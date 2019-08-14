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
end
