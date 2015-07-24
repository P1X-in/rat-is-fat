extends "res://scripts/moving_object.gd"

var destination = [0, 0]
var aggro_range = 200
var attack_range = 50

func _init(bag).(bag):
    self.initial_position = Vector2(200, 200)
    self.velocity = 5
    self.movement_vector = [0.3, 0.3]

func go_to(x, y):
    self.destination[0] = x
    self.destination[1] = y

func process_ai():
    return

func process(delta):
    self.process_ai()
    self.modify_position()