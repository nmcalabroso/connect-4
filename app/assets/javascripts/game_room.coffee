initialize_game_board = ->
  self_data = this

  this.your_turn = $('#game-room').data('player-turn') == parseInt(localStorage.getItem 'player_number', 10)

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
  this.update_server_game_board this.game_board
  this.your_turn = false
  return

stringify_game_board = (game_board) ->
  reducer = (current_string, current_element) ->
    current_string + current_element

  result = game_board.map (row) ->
    row.reduce reducer, ''

  return result.reduce reducer, ''

string_to_game_board = (string_game_board) ->
  []

update_server_game_board = (game_board) ->
  game_room_id = $('#game-room').data 'id'
  url = '/game_rooms/' + game_room_id + '/game_board'

  user =
    username: localStorage.getItem 'username'
    player_number: parseInt localStorage.getItem 'player_number', 10

  $.ajax
    url: url
    method: 'PATCH'
    dataType: 'json'
    data:
      user: user
      game_board: stringify_game_board(game_board)

  return

game_board_vm = new Vue
  el: '#game-room'
  data:
    your_turn: false
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
    update_server_game_board: update_server_game_board

game_room_id = $('#game-room').data 'id'
url = '/game_rooms/' + game_room_id + '/game_board'
PrivatePub.subscribe url, (data) ->
  game_board_vm.your_turn = data.next_turn == parseInt(localStorage.getItem('player_number'), 10)
  game_board_vm.game_board = string_to_game_board data.game_board
  return
