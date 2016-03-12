class GameRoomsController < ApplicationController
  def create
    username = game_room_params[:username]
    room_name = "Room by #{ username }"
    game_room = GameRoom.create(name: room_name, first_player: username)

    publish_game_rooms

    respond_to do |format|
      format.json {
        render json: { username: game_room.first_player, game_room: game_room }, status: :ok
      }
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

  def join
    game_room = GameRoom.find(params[:id])
    unless game_room.open?
      render status: :bad_request
      return
    end

    game_room.second_player = auto_generated_username
    game_room.save
    game_room.on_going!
    publish_game_rooms

    respond_to do |format|
      format.json {
        render json: { username: game_room.second_player, game_room: game_room }, status: :ok
      }
    end
  end

  private

  def game_room_params
    params.require(:game_room).permit(:username)
  end

  def auto_generated_username
    return 'User ' + SecureRandom.random_number(100).to_s
  end

  def publish_game_rooms
    game_rooms = GameRoom.open
    PrivatePub.publish_to '/game_rooms/all', game_rooms: game_rooms
  end
end
