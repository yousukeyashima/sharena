class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_user

  def show
    @restaurants = Restaurant.where(user_id: @user.id)
    @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
      marker.lat restaurant.latitude
      marker.lng restaurant.longitude
      marker.infowindow render_to_string(partial: "restaurants/infowindow", locals: {restaurant: restaurant})
    end
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def followed
    #@userがフォローしているユーザー
    @users = @user.followed
    render 'show_follow'
  end

  def followers
    #@userをフォローしているユーザー
    @users = @user.followers
    render 'show_follower'
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
