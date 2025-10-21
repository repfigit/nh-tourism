class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities do |t|
      t.string :name, null: false
      t.text :description
      t.string :duration
      t.string :difficulty, default: "Moderate"
      t.string :slug, null: false


      t.timestamps
    end
  end
end
