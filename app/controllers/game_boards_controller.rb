class GameBoardsController < ApplicationController
  def update
    game_room = GameRoom.find(params[:id])
    user = params[:user]
    game_board = params[:game_board]
    next_turn = next_player user[:player_number].to_i

    respond_to do |format|
      if game_room.playing_by? user[:username]
        if game_room.turn_now? user[:player_number].to_i
          game_room.update(game_board: game_board, next_turn: next_turn)
          result = { user: user, game_room: game_room }
          PrivatePub.publish_to game_board_path(game_room), result
          status = :ok
        else
          result = { message: 'not_user_turn' }
          status = :bad_request
        end
      else
        result = { message: 'invalid_user' }
        status = :bad_request
      end
      format.json { render json: result, status: status }
    end
  end

  private

  def next_player(player_number)
    if player_number == 1
      return 2
    elsif player_number == 2
      return 1
    end
  end
end
