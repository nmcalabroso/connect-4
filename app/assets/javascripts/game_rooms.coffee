create_game_room = (e) ->
  e.preventDefault()
  username = $('input#username').val()

  $.ajax
    url: '/game_rooms'
    type: 'POST'
    dataType: 'json'
    data:
      username: username
    success: (result) ->
      console.log(result)
      window.location.href = '/game_rooms/' + result.game_room.id;

  return

create_game_room_button = $('button#create-game-room');
create_game_room_button.click(create_game_room);
