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
      window.location.href = '/game_rooms/' + data.game_room.id;
      return
  return

vm = new Vue
  el: '#game-rooms'
  data:
    game_rooms: []
  methods:
    create_game_room: create_game_room
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
  vm.game_rooms.push data.game_room
  return
