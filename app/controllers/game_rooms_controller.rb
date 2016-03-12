class GameRoomsController < ApplicationController
  def create
    username = game_room_params[:username]
    room_name = "Room by #{ username }"
    game_room = GameRoom.create(name: room_name, first_player: username)

    PrivatePub.publish_to '/game_rooms/all', game_room: game_room

    respond_to do |format|
      format.json { render json: { game_room: game_room }, status: :ok }
    end
  end

  def index
    game_rooms = GameRoom.open

    respond_to do |format|
      format.json { render json: { game_rooms: game_rooms }, status: :ok }
      format.html { render 'game_rooms/index' }
    end
  end

  def show
    @game_room = {id: 123456, name: 'meyagen'}
  end

  def game_room_params
    params.require(:game_room).permit(:username)
  end
end
