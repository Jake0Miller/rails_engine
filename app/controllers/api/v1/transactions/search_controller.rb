class Api::V1::Transactions::SearchController < ApplicationController
  def show
    transaction = Transaction.find_by(transaction_params)
    render json: TransactionSerializer.new(transaction)
  end

  def index
    transactions = Transaction.where(transaction_params).order(id: :asc)
    render json: TransactionSerializer.new(transactions)
  end

  private

  def transaction_params
    params.permit(:id, :credit_card_number, :result, :created_at, :updated_at, :invoice_id)
  end
end
