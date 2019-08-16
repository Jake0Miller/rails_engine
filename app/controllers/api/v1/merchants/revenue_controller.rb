class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    revenue = Invoice.total_revenue_by_date(params[:date])[0]
    render json: RevenueSerializer.new(revenue)
  end
end
