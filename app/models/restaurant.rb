class Restaurant < ApplicationRecord
#住所からlatitude,longitudeカラムを自動作成
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
#latitude,longitudeから住所取得
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  attachment :restaurant_image
  belongs_to :user
  #コメント機能
  has_many :post_comments, dependent: :destroy
  #いいね機能
  has_many :favorites, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

end
