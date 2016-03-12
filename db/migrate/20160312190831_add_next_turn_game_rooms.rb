class AddNextTurnGameRooms < ActiveRecord::Migration
  def change
    add_column :game_rooms, :next_turn, :integer, default: 1
  end
end
