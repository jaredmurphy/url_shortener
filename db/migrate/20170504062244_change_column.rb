class ChangeColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :urls, :short_link, :string, :null => true 
  end
end
