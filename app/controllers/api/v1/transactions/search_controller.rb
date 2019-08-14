class Api::V1::Transactions::SearchController < ApplicationController
  def show
    item = Transaction.find_by(item_params)
    render json: TransactionSerializer.new(item)
  end

  def index
    items = Transaction.where(item_params)
    render json: TransactionSerializer.new(items)
  end

  private

  def item_params
    params.permit(:id, :first_name, :last_name, :created_at, :updated_at, :merchant_id)
  end
end
