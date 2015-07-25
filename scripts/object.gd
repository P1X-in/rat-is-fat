var bag

var hp
var max_hp

var avatar
var is_processing = false
var initial_position = Vector2(0, 0)
var push_back = false

func _init(bag):
    self.bag = bag
    self.max_hp = 10
    self.hp = 10


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
    var position = self.get_pos()
    var global_x = position.x / self.bag.camera.zoom.x
    var global_y = position.y / self.bag.camera.zoom.y
    return Vector2(global_x, global_y)

func spawn(position):
    self.attach()
    self.initial_position = position
    self.avatar.set_pos(self.initial_position)

func despawn():
    self.detach()
    self.avatar.queue_free()

func attach():
    self.is_processing = true
    self.bag.action_controller.attach_object(self.avatar)

func detach():
    self.is_processing = false
    self.bag.action_controller.detach_object(self.avatar)

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

func recieve_damage(damage):
    self.set_hp(self.hp - damage)


