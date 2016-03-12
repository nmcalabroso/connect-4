class GameBoardsController < ApplicationController
  def update
    game_room = GameRoom.find(params[:id])
    user = game_board_params[:user]
    game_board = game_board_params[:game_board]

    respond_to do |format|
      if game_room.playing_by? user[:username]
        if game_room.turn_by? user[:player_number]
          game_room.game_board.update(game_board: game_board)
          result = { user: user, game_board: game_board }
          PrivatePub.publish_to game_board_path(game_room), result
          status = :ok
        end

        result = { message: 'not_user_turn' }
        status = :bad_request
      else
        result = { message: 'invalid_user' }
        status = :bad_request
      end

      format.json { render json: result, status: status }
    end
  end

  private

  def game_board_params
    params.require('user', 'game_board')
  end
end
