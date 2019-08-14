class Api::V1::Customers::SearchController < ApplicationController
  def show
    item = Customer.find_by(item_params)
    render json: CustomerSerializer.new(item)
  end

  def index
    items = Customer.where(item_params)
    render json: CustomerSerializer.new(items)
  end

  private

  def item_params
    params.permit(:id, :first_name, :last_name, :created_at, :updated_at, :merchant_id)
  end
end
