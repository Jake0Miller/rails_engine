class Api::V1::Invoices::CustomerController < ApplicationController
  def index
    render json: CustomerSerializer.new(Customer.customer_on_invoice(params[:id])[0])
  end
end
