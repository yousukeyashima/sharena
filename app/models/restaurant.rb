class Restaurant < ApplicationRecord
#住所からlatitude,longitudeカラムを自動作成
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
#latitude,longitudeから住所取得
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  attachment :restaurant_image
  belongs_to :user
  has_many :post_comments#, dependent: :destroy
  has_many :favorites#, dependent: :destory

  validates :name, presence: true
  validates :address, presence: true

  def faorites_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
