class Api::V1::Items::ItemSalesController < ApplicationController
  def show
    date = Item.date_of_highset_sales(params[:id])
    render json: DateSerializer.new(date[0])
  end

  def index
    items = Item.most_sold(params[:quantity])
    render json: ItemSerializer.new(items)
  end
end
