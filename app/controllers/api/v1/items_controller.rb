class Api::V1::ItemsController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def index
    render json: ItemSerializer.new(Item.all)
  end
end
