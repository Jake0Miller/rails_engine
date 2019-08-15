class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    revenue = Invoice.total_revenue_by_date(params[:date])
    render json: RevenueSerializer.new(revenue[0])
  end
end
