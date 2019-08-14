class Api::V1::Invoices::MerchantController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.merchant_on_invoice(params[:id])[0])
  end
end
