class CreateGameRooms < ActiveRecord::Migration
  def change
    create_table :game_rooms do |t|
      t.string :name
      t.string :first_player
      t.string :second_player
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
