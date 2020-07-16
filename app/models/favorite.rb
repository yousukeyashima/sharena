class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  validates_uniqueness_of :restaurant_id, scope: :user_id
end
