initialize_game_board = ->
  self_data = this
  first_dimension = Array.apply(null, Array(this.game_board_width)).map ->
    return 0

  this.game_board = first_dimension.map ->
    return Array.apply(null, Array(self_data.game_board_height)).map ->
      return 0

  this.next_rows_per_column = first_dimension.map ->
    return self_data.game_board_height - 1

  return

insert_to_column = (col, event) ->
  event.preventDefault()

  row = this.next_rows_per_column[col]
  player_number = localStorage.getItem 'player_number'

  this.game_board[row][col] = parseInt player_number, 10
  this.next_rows_per_column[col] = row - 1

  this.game_board.$set(row, this.game_board[row]);
  return

stringify_game_board = (game_board) ->
  reducer = (current_string, current_element) ->
    current_string + current_element

  result = game_board.map (row) ->
    row.reduce reducer, ''

  return result.reduce reducer, ''

game_board_vm = new Vue
  el: '#game-room'
  data:
    game_board_height: 7
    game_board_width: 7
    game_board: []
    next_rows_per_column: 7
  ready: initialize_game_board
  computed:
    true_game_board: ->
      return this.game_board
  methods:
    insert_to_column: insert_to_column
    stringify_game_board: stringify_game_board
