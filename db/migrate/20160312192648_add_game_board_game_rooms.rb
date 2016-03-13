class AddGameBoardGameRooms < ActiveRecord::Migration
  def change
    add_column :game_rooms, :game_board, :text, default: '0' * 49
  end
end
