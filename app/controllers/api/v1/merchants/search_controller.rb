class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.find_by(merchant_params)
    render json: MerchantSerializer.new(merchant)
  end

  def index
    merchants = Merchant.where(merchant_params)
    render json: MerchantSerializer.new(merchants)
  end

  private

  def merchant_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
