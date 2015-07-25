extends "res://scripts/object.gd"

var velocity
var movement_vector = [0, 0]

var AXIS_THRESHOLD = 0.15

var body_part_head
var body_part_body
var body_part_footer

func _init(bag).(bag):
    self.bag = bag

func spawn():
    self.is_processing = true
    self.bag.action_controller.game_board.add_child(self.avatar)
    self.avatar.set_pos(self.initial_position)
    self.bag.processing.register(self)

func despawn():
    self.bag.processing.remove(self)
    self.bag.action_controller.game_board.remove_child(self.avatar)
    self.avatar.queue_free()

func die():
    self.is_processing = false
    self.despawn()

func process(delta):
    self.modify_position(delta)

func modify_position(delta):
    var x = self.apply_axis_threshold(self.movement_vector[0])
    var y = self.apply_axis_threshold(self.movement_vector[1])
    var motion = Vector2(x, y) * self.velocity * delta
    self.avatar.move(motion)
    self.flip(self.movement_vector[0])

func apply_axis_threshold(axis_value):
    if abs(axis_value) < self.AXIS_THRESHOLD:
        return 0
    return axis_value

func flip(direction):
    if direction == 0:
        return

    var flip_sprite = false
    if direction > 0:
        flip_sprite = true

    self.body_part_head.set_flip_h(flip_sprite)
    self.body_part_body.set_flip_h(flip_sprite)
    self.body_part_footer.set_flip_h(flip_sprite)

func reset_movement():
    self.movement_vector = [0, 0]
