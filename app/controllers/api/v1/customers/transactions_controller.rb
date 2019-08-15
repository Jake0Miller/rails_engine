class Api::V1::Customers::TransactionsController < ApplicationController
  def index
    render json: TransactionSerializer.new(Transaction.transactions_for_customer(params[:id]))
  end
end
