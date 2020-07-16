class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurant.all
    @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
      marker.lat restaurant.latitude
      marker.lng restaurant.longitude
      marker.infowindow render_to_string(partial: "restaurants/infowindow", locals: {restaurant: restaurant})
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @comment = PostComment.new
    @comments =@restaurant.post_comments.order(created_at: :desc) #新着順で表示
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
      redirect_to root_path
    else
      render :new
    end
  end

  def update
  end

  def destroy
  end

  def map
  results = Geocoder.search(params[:address])
  @latlng = results.first.coordinates

  # respond_to以下の記述によって、
  # remote: trueのアクセスに対して、
  # map.js.erbが変えるようになります。
  respond_to do |format|
    format.js
  end
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :restaurant_image, :description, :address)
  end
end
