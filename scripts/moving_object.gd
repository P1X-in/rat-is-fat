extends "res://scripts/object.gd"

var velocity
var movement_vector = [0, 0]

var AXIS_THRESHOLD = 0.15

var screen = OS.get_video_mode_size()

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
    self.bag.action_controller.game_board.remove_child(self.avatar)

func die():
    self.is_processing = false
    self.despawn()

func process(delta):
    self.modify_position()

func modify_position():
    var position = self.avatar.get_pos()
    var new_position = Vector2(0, 0)
    var zoom = self.bag.camera.zoom

    new_position.x = self.calculate_position(self.movement_vector[0], position.x, self.screen.x * zoom.x)
    new_position.y = self.calculate_position(self.movement_vector[1], position.y, self.screen.y * zoom.y)
    self.avatar.set_pos(new_position)
    self.flip(self.movement_vector[0])

func calculate_position(axis_value, old_position, screen_limit):
    if abs(axis_value) < self.AXIS_THRESHOLD:
        return old_position

    var speed = axis_value * self.velocity
    var new_position = old_position + speed
    if new_position < 0:
        new_position = 0
    elif new_position > screen_limit:
        new_position = screen_limit

    return new_position

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
