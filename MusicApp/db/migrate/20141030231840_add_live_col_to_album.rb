class AddLiveColToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :live ,:boolean, null: false
  end
end
