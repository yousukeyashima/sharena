class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    #投稿絞り込みや地図絞り込みがない場合、全店表示
    # if params[:restaurant].nil?
    #   @latitude = 34.6873153
    #   @longitude = 135.52620130000003
    #   @restaurants = Restaurant.all
    # else
    #   if params[:place_search] == ""
    #     @latitude = 34.6873153
    #     @longitude = 135.52620130000003
    #   else
    #     @place_search = params[:restaurant][:address]
    #     results = Geocoder.search("#{@place_search}")
    #     #@latlng = results.first.coordinates
    #     @latitude = results.first.latitude.to_f
    #     @longitude = results.first.longitude.to_f
    #     #@latitude = results.first.latitude.to_f
    #     #@longitude = results.first.longitude.to_f
    #   end

      # #投稿絞り込み
      # if params[:example] == "1"
      #   @restaurants = Restaurant.all
      # elsif params[:example] == "2"
      #   #@user  = User.find_by(id: current_user.id)
      #   @users = current_user.followed
      #   @restaurants = []
      #   if @users.present?
      #     @users.each do |user|
      #       restaurants = Restaurant.where(user_id: user.id)
      #       @restaurants.concat(restaurants)
      #     end
      #   end
      # elsif params[:example] == "3"
      #   #@user = User.find_by(id: current_user.id)
      #   @favorites = current_user.favorites
      #   #@restaurants = @favorites.restaurant
      #   @restaurants = @favorites.map{|favorite| favorite.restaurant}
      # else
      #   redirect_to restaurants_path
      # end

      # end
      @restaurants = Restaurant.all
    #現在地を取得
    if params[:latitude].nil? && params[:longitude].nil?
      @latitude = 34.6873153
      @longitude = 135.52620130000003
      @zoom = 11
    else
      @latitude = params[:latitude].to_f
      @longitude = params[:longitude].to_f
      @zoom = 17
    end

    #地図とマーカーをセット
    @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
      marker.lat restaurant.latitude
      marker.lng restaurant.longitude
      marker.infowindow render_to_string(partial: "restaurants/infowindow", locals: {restaurant: restaurant})
    end
  end

  def search_location
    if params[:latitude].nil? && params[:longitude].nil?
      @latitude = 34.6873153
      @longitude = 135.52620130000003
    else
        @latitude = params[:latitude].to_f
        @longitude = params[:longitude].to_f
      end
        #@locations = Restaurant.within_box(0.5, @latitude, @longitude)
        @restaurants = Restaurant.all
        @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
          marker.lat restaurant.latitude
          marker.lng restaurant.longitude
          marker.infowindow render_to_string(partial: "restaurants/infowindow", locals: {restaurant: restaurant})
        end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @user = User.find_by(id: @restaurant.user_id)
    @comment = PostComment.new
    @comments =@restaurant.post_comments#.order(created_at: :desc) #新着順で表示
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
    params.require(:restaurant).permit(:name, :restaurant_image, :description, :address, :place_search)
  end
end
