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
end
