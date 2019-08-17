class Api::V1::Merchants::FavoriteCustomerController < ApplicationController
  def show
    fav_customer = Customer.favorite_customer(params[:id])[0]
    render json: CustomerSerializer.new(fav_customer)
  end
end
