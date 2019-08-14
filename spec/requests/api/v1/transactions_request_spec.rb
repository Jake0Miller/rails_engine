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

  it 'can get the invoice for the transaction' do
    transaction = create(:transaction)
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    transaction.update_attributes(invoice_id: invoice_2.id)

    get "/api/v1/transactions/#{transaction.id}/invoice"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)["data"]

    expect(invoice["id"].to_i).to eq(invoice_2.id)
  end

  describe 'lookups' do
    before :each do
      @invoice = create(:invoice)
      @trans_2 = @invoice.transactions.create!(credit_card_number: '2468', result: 'success', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
      @trans_1 = @invoice.transactions.create!(credit_card_number: '1234', result: 'success', created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
    end

    it 'can get find one transaction by search params' do
      get "/api/v1/transactions/find?id=#{@trans_1.id}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@trans_1.id)
      expect(transaction["attributes"]["credit_card_number"]).to eq(@trans_1.credit_card_number)
      expect(transaction["attributes"]["result"]).to eq(@trans_1.result)

      get "/api/v1/transactions/find?credit_card_number=#{@trans_1.credit_card_number}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@trans_1.id)
      expect(transaction["attributes"]["credit_card_number"]).to eq(@trans_1.credit_card_number)
      expect(transaction["attributes"]["result"]).to eq(@trans_1.result)

      get "/api/v1/transactions/find?created_at=#{@trans_2.created_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@trans_2.id)
      expect(transaction["attributes"]["credit_card_number"]).to eq(@trans_2.credit_card_number)
      expect(transaction["attributes"]["result"]).to eq(@trans_2.result)

      get "/api/v1/transactions/find?updated_at=#{@trans_2.updated_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(@trans_2.id)
      expect(transaction["attributes"]["credit_card_number"]).to eq(@trans_2.credit_card_number)
      expect(transaction["attributes"]["result"]).to eq(@trans_2.result)
    end

    it 'can get find multiple transactions by search params' do
      get "/api/v1/transactions/find_all?name=#{@trans_1.created_at}"

      transactions = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transactions.length).to eq(2)
      expect(transactions[1]["id"].to_i).to eq(@trans_1.id)
      expect(transactions[1]["attributes"]["credit_card_number"]).to eq(@trans_1.credit_card_number)
      expect(transactions[0]["id"].to_i).to eq(@trans_2.id)
      expect(transactions[0]["attributes"]["credit_card_number"]).to eq(@trans_2.credit_card_number)
    end

    it 'can get a random transaction' do
      get "/api/v1/transactions/random"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect([@trans_1.id, @trans_2.id]).to include(transaction["id"].to_i)
      expect([@trans_1.credit_card_number, @trans_2.credit_card_number]).to include(transaction["attributes"]["credit_card_number"])
    end
  end
end
