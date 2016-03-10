class GameRoomsController < ApplicationController
  def create
    result = {game_room: {id: 123456}}
    respond_to do |format|
      format.json { render json: result, status: :ok }
    end
  end

  def show
    @game_room = {id: 123456, name: 'meyagen'}
  end
end
