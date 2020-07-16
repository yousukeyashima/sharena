class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  has_many :restaurants, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  #いいね機能
  has_many :favorites, dependent: :destroy
  # フォロー機能
  has_many :followed_relationships, foreign_key: "follower_id", class_name: "Relationship",  dependent: :destroy
  has_many :followed, through: :followed_relationships
  has_many :follower_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships

  #いいね済みかどうか
  def already_favorited?(restaurant)
    self.favorites.exists?(restaurant_id: restaurant.id)
  end

   #フォローしているかを確認するメソッド
  def following?(user)
    followed_relationships.find_by(followed_id: user.id)
  end

  #フォローするときのメソッド
  def follow(user)
    followed_relationships.create!(followed_id: user.id)
  end

  #フォローを外すときのメソッド
  def unfollow(user)
    followed_relationships.find_by(followed_id: user.id).destroy
  end
end
