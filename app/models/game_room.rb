class GameRoom < ActiveRecord::Base
  enum status: [ :open, :on_going, :done, :close ]
end
