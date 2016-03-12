initialize_game_board = ->
  self_data = this
  this.game_board_height = 7
  this.game_board_width = 7

  first_dimension = Array.apply(null, Array(this.game_board_width)).map ->
    return 0

  this.game_board = first_dimension.map ->
    return Array.apply(null, Array(self_data.game_board_height)).map ->
      return 0

  return

game_board_vm = new Vue
  el: '#game-room'
  init: initialize_game_board
