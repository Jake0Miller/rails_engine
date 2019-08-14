class Api::V1::InvoiceItems::ItemController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.item_on_invoice_item(params[:id])[0])
  end
end
