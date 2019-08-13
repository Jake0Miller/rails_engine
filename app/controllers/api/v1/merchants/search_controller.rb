class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.find_by(params.keys[0][params.values[0]])
    render json: MerchantSerializer.new(merchant)
  end

  def index
    merchants = Merchant.where(params.keys[0] [params.values[0]])
    render json: MerchantSerializer.new(merchants)
  end
end
