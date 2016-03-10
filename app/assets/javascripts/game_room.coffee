BOARD_WIDTH = 7
BOARD_HEIGHT = 7

game_board = null

initialize_game_board = ->
  first_dimension = Array.apply(null, Array(BOARD_WIDTH)).map ->
    return 0
   
  return first_dimension.map ->
    return Array.apply(null, Array(BOARD_HEIGHT)).map ->
      return 0

game_board = initialize_game_board()
