class Api::V1::InvoiceItems::SearchController < ApplicationController
  def show
    invoice_item = InvoiceItem.find_by(invoice_item_params)
    render json: InvoiceItemSerializer.new(invoice_item)
  end

  def index
    invoice_items = InvoiceItem.where(invoice_item_params).order(id: :asc)
    render json: InvoiceItemSerializer.new(invoice_items)
  end

  private

  def invoice_item_params
    params.permit(:id, :quantity, :unit_price, :created_at, :updated_at, :invoice_id, :item_id)
  end
end
