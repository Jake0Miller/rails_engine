class Api::V1::Customers::MerchantController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.fav_for_customer(params[:id])[0])
  end
end
