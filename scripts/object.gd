var bag

var hp
var max_hp

var avatar
var is_processing = false
var initial_position = Vector2(0, 0)

func _init(bag):
    self.bag = bag
    self.max_hp = 1
    self.hp = 1


func get_hp():
    return self.hp

func set_hp(hp):
    if hp <= 0:
        self.die()
    else:
        if hp <= self.max_hp:
            self.hp = hp
        else:
            self.hp = self.max_hp

func get_pos():
    return self.avatar.get_pos()

func get_screen_pos():
    return self.get_pos() + Vector2(100, 100)

func spawn():
    self.is_processing = true
    self.bag.action_controller.game_board.add_child(self.avatar)
    self.avatar.set_pos(self.initial_position)

func despawn():
    self.bag.action_controller.game_board.remove_child(self.avatar)

func die():
    self.is_processing = false
    self.despawn()

func calculate_distance_to_object(moving_object):
    return self.calculate_distance(moving_object.get_pos())

func calculate_distance(their_position):
    var my_position = self.get_pos()
    var delta_x = abs(my_position.x) - abs(their_position.x)
    var delta_y = abs(my_position.y) - abs(their_position.y)

    return sqrt(delta_x * delta_x + delta_y * delta_y)
