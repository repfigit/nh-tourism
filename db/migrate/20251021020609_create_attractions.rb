class CreateAttractions < ActiveRecord::Migration[7.2]
  def change
    create_table :attractions do |t|
      t.string :name, null: false
      t.string :location
      t.text :description
      t.string :category, default: "Outdoor"
      t.string :image_url
      t.string :slug, null: false


      t.timestamps
    end
  end
end
