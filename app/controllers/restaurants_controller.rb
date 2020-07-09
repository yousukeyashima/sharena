class RestaurantsController < ApplicationController


  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :restaurant_image, :description, :address)
  end
end
