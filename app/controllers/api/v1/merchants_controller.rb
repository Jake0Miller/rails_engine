class Api::V1::MerchantsController < ApplicationController
  def show
    render json: Merchant.find(params[:id])
  end

  def index
    render json: Merchant.all
  end
end
