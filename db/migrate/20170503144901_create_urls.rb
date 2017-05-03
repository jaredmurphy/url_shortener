class CreateUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :urls do |t|
      t.string :full_link, null: false
      t.string :short_link, null: false
      t.integer :access_count, null: false, default: 0 

      t.timestamps
    end
  end
end
