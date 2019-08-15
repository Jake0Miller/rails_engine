class Api::V1::Items::MerchantController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.merchant_on_item(params[:id])[0])
  end
end
