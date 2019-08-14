class Api::V1::Invoices::SearchController < ApplicationController
  def show
    invoice = Invoice.find_by(invoice_params)
    render json: InvoiceSerializer.new(invoice)
  end

  def index
    invoices = Invoice.where(invoice_params).order(id: :asc)
    render json: InvoiceSerializer.new(invoices)
  end

  private

  def invoice_params
    params.permit(:id, :status, :created_at, :updated_at, :merchant_id, :customer_id)
  end
end
