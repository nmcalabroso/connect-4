initialize_game_board = ->
  self_data = this

  this.your_turn = $('#game-room').data('player-turn') == parseInt(localStorage.getItem 'player_number', 10)

  first_dimension = Array.apply(null, Array(this.game_board_width)).map ->
    return 0

  this.game_board = this.string_to_game_board($('#game-room').data('game-board'), this.game_board_width, this.game_board_height)
  this.next_rows_per_column = this.initial_next_rows_per_column(this.game_board, this.game_board_width, this.game_board_height)
  return

insert_to_column = (col, event) ->
  event.preventDefault()

  row = this.next_rows_per_column[col]
  player_number = localStorage.getItem 'player_number'

  this.game_board[row][col] = parseInt player_number, 10
  this.next_rows_per_column[col] = row - 1

  this.update_server_game_board this.game_board
  this.your_turn = false
  return

stringify_game_board = (game_board) ->
  reducer = (current_string, current_element) ->
    current_string + current_element

  result = game_board.map (row) ->
    row.reduce reducer, ''

  return result.reduce reducer, ''

string_to_game_board = (string_game_board, width, height) ->
  game_board = []

  i = 0
  while i < height
    start_index = width * i
    end_index = start_index + width
    row = string_game_board.slice(start_index, end_index).split('').map( (e) ->
      return parseInt(e, 10)
    )
    game_board.push(row)
    i = i + 1

  return game_board

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

initial_next_rows_per_column = (game_board, width, height) ->
  next_rows_per_column = {}
  i = height - 1
  while i >= 0
    current_row = game_board[i]
    j = 0
    while j < current_row.length
      if current_row[j] == 0 && !next_rows_per_column[j]
        next_rows_per_column[j] = i
      j = j + 1
    i = i - 1

  return next_rows_per_column

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
    initial_next_rows_per_column: initial_next_rows_per_column
    string_to_game_board: string_to_game_board

game_room_id = $('#game-room').data 'id'
url = '/game_rooms/' + game_room_id + '/game_board'
PrivatePub.subscribe url, (data) ->
  game_board_vm.your_turn = data.game_room.next_turn == parseInt(localStorage.getItem('player_number'), 10)
  game_board_vm.game_board = string_to_game_board(data.game_room.game_board, 7, 7)
  game_board_vm.next_rows_per_column = initial_next_rows_per_column(game_board_vm.game_board, 7, 7)
  return
