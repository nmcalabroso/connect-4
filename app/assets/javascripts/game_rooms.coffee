create_game_room = (username, event) ->
  event.preventDefault()
  $.ajax
    url: '/game_rooms'
    type: 'POST'
    dataType: 'json'
    data:
      game_room:
        username: username
    success: (data) ->
      localStorage.setItem 'username', data.username
      window.location.href = '/game_rooms/' + data.game_room.id;
      return
  return

join_game_room = (game_room, event) ->
  event.preventDefault()
  $.ajax
    url: '/game_rooms/' + game_room.id.toString() + '/join'
    type: 'PATCH'
    dataType: 'json'
    success: (data) ->
      if !localStorage.getItem('username')
        localStorage.setItem 'username', data.username

      window.location.href = '/game_rooms/' + data.game_room.id;
      return
  return

game_rooms_vm = new Vue
  el: '#game-rooms'
  data:
    username: ''
    game_rooms: []
  methods:
    create_game_room: create_game_room
    join_game_room: join_game_room
  init: ->
    self_data = this
    $.ajax
      url: '/game_rooms'
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        self_data.game_rooms = data.game_rooms
        return
      error: ->
        self_data.game_rooms = []
        return
    return

PrivatePub.subscribe '/game_rooms/all', (data) ->
  game_rooms_vm.game_rooms.push data.game_room
  return
