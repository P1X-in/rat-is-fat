
var bag

var player_template = preload("res://scripts/player.gd")
var players = []

func _init_bag(bag):
    self.bag = bag
    self.bind_players()

func bind_players():
    self.players = [
        self.player_template.new(self.bag, 0),
        self.player_template.new(self.bag, 1),
        #self.player_template.new(self.bag, 2),
        #self.player_template.new(self.bag, 3),
    ]
    #self.players[0].bind_keyboard_and_mouse()

func move_to_entry_position(name):
    for player in self.players:
        player.move_to_entry_position(name)

func is_living_player_in_game():
    for player in self.players:
        if player.is_playing && player.is_alive:
            return true
    return false

func respawn():
    for player in self.players:
        player.respawn()

func reset():
    for player in self.players:
        player.reset()

func remove_remaining_players():
    for player in self.players:
        if player.is_playing && player.is_alive:
            player.remove_from_game()

func get_first_free_entry_position_num(player_id):
    var position = 0
    for player in self.players:
        if player.is_playing && player.is_alive && player.player_id < player_id:
            position = position + 1
    return position