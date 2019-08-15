class Api::V1::Transactions::InvoiceController < ApplicationController
  def show
    render json: InvoiceSerializer.new(Invoice.invoice_on_transaction(params[:id])[0])
  end
end
