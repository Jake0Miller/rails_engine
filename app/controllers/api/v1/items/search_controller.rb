class Api::V1::Items::SearchController < ApplicationController
  def show
    item = Item.order_by_id.find_by(item_params)
    render json: ItemSerializer.new(item)
  end

  def index
    items = Item.order_by_id.where(item_params)
    render json: ItemSerializer.new(items)
  end

  private

  def item_params
    params[:unit_price] = (params[:unit_price].to_f*100).round(0) if params[:unit_price]
    params.permit(:id, :name, :description, :unit_price, :created_at, :updated_at, :merchant_id)
  end
end
