var bag

var hp
var max_hp

var hit_protection = false
var is_invulnerable = false
var invulnerability_period = 0.5

var avatar
var is_processing = false
var initial_position = Vector2(0, 0)
var score = 100

var sounds = {
    'attack' : null,
    'die' : null,
    'hit' : null,
}

func _init(bag):
    self.bag = bag
    self.max_hp = 5
    self.hp = 5


func get_hp():
    return self.hp

func set_hp(hp):
    if hp <= 0:
        self.hp = 0
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

func attach():
    self.is_processing = true
    self.bag.action_controller.attach_object(self.avatar)

func detach():
    self.is_processing = false
    self.bag.action_controller.detach_object(self.avatar)

func die():
    self.play_sound('die')
    self.is_processing = false
    self.despawn()

func calculate_distance_to_object(moving_object):
    return self.calculate_distance(moving_object.get_pos())

func calculate_distance(their_position):
    return self.get_pos().distance_to(their_position)

func recieve_damage(damage):
    if self.is_invulnerable:
        return

    self.play_sound('hit')
    self.set_hp(self.hp - damage)

    if self.hit_protection:
        self.is_invulnerable = true
        self.bag.timers.set_timeout(self.invulnerability_period, self, "loose_invulnerability")


func loose_invulnerability():
    self.is_invulnerable = false

func will_die(damage):
    return damage >= self.hp

func play_sound(name):
    if self.sounds[name] != null:
        self.bag.sample_player.play(self.sounds[name])

func make_invulnerable(duration=null):
    if duration == null:
        return
    self.is_invulnerable = true
    self.bag.timers.set_timeout(duration, self, "remove_invulnerable")

func remove_invulnerable():
    self.is_invulnerable = false
