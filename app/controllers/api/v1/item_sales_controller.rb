class Api::V1::ItemSalesController < ApplicationController
  def show
    
  end

  def index
    num_items = params[:quantity].to_i
    render json: ItemSerializer.new(Item.most_sold(num_items))
  end
end
