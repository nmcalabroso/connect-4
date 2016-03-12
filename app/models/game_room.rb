class GameRoom < ActiveRecord::Base
  enum status: [ :open, :on_going, :done, :close ]

  def playing_by?(username)
    return [ self.first_player, self.second_player ].include username
  end

  def turn_now?(player_number)
    return self.next_turn == player_number
  end
end
