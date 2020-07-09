class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.string :restaurant_image_id
      t.text :description
      t.string :address, null: false
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
