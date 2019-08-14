class Api::V1::InvoiceItemsController < ApplicationController
  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find(params[:id]))
  end

  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.all)
  end
end
