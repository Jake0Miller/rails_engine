class Api::V1::Merchants::TotalRevenueController < ApplicationController
  def show
    if params[:date]
      revenue = Invoice.total_revenue_by_merch_and_date(params[:id],params[:date])[0]
    else
      revenue = Invoice.total_revenue(params[:id])[0]
    end
    render json: RevenueSerializer.new(revenue)
  end
end
