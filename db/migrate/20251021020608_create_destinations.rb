class CreateDestinations < ActiveRecord::Migration[7.2]
  def change
    create_table :destinations do |t|
      t.string :name, null: false
      t.string :location
      t.text :description
      t.boolean :featured, default: false
      t.string :image_url
      t.string :slug, null: false


      t.timestamps
    end
  end
end
