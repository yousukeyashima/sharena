class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :top]

  PER = 16

  def top
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result(distinct: true).page(params[:page]).per(PER)
    #現在地を取得
    if params[:latitude].nil? && params[:longitude].nil?
      @latitude = 34.6873153
      @longitude = 135.52620130000003
      @zoom = 11
    else
      @latitude = params[:latitude].to_f
      @longitude = params[:longitude].to_f
      @zoom = 15
    end

    #地図とマーカーをセット
    @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
      marker.lat restaurant.latitude
      marker.lng restaurant.longitude
      marker.infowindow render_to_string(partial: "restaurants/infowindow", locals: {restaurant: restaurant})
    end
  end

  def index
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result(distinct: true).page(params[:page]).per(PER)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @user = User.find_by(id: @restaurant.user_id)
    @comment = PostComment.new
    @comments =@restaurant.post_comments
    #mapにmarker設置
    @latitude = @restaurant.latitude
    @longitude = @restaurant.longitude
    @hash = Gmaps4rails.build_markers(@restaurant) do |restaurant, marker|
      marker.lat restaurant.latitude
      marker.lng restaurant.longitude
      marker.infowindow render_to_string(partial: "restaurants/infowindow", locals: {restaurant: restaurant})
    end
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id
    if @restaurant.save
      tags = Vision.get_image_data(@restaurant.restaurant_image)
      tags.each do |tag|
        @restaurant.tags.create(name: tag)
      end
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to restaurant_path(@restaurant.id)
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    unless @restaurant.user_id == current_user.id
      redirect_to restaurant_path(@restaurant.id)
    else
      @restaurant.destroy
      redirect_to restaurants_path
    end
  end


  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :restaurant_image, :description, :address, :place_search)
  end
end
