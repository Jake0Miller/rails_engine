class Api::V1::Items::SearchController < ApplicationController
  def show
    item = Item.find_by(item_params)
    render json: ItemSerializer.new(item)
  end

  def index
    items = Item.where(item_params)
    render json: ItemSerializer.new(items)
  end

  private

  def item_params
    params.permit(:id, :name, :description, :unit_price, :created_at, :updated_at, :merchant_id)
  end
end
