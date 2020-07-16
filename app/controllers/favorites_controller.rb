class FavoritesController < ApplicationController

  before_action :restaurant_params

  def create
    favorite = current_user.favorites.new(restaurant_id: @restaurant.id)
    favorite.save
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, restaurant_id: @restaurant.id).destroy
  end

  private
  def restaurant_params
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
