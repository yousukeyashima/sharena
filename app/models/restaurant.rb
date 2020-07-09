class Restaurant < ApplicationRecord
  attachment :image
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destory

  validates :name, presence: true
  validates :address, presence: true

  def faorites_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
