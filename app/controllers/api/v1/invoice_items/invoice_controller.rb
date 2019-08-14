class Api::V1::InvoiceItems::InvoiceController < ApplicationController
  def show
    render json: InvoiceSerializer.new(Invoice.invoice_on_invoice_item(params[:id])[0])
  end
end
