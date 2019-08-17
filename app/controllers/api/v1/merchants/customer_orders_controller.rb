class Api::V1::Merchants::CustomerOrdersController < ApplicationController
  def index
    customers = Customer.pending_invoices(params[:id])
    render json: CustomerSerializer.new(customers)
  end
end
