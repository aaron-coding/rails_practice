class AddBonusToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :bonus, :string, null: false
  end
end
