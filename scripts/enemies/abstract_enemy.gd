extends "res://scripts/moving_object.gd"

var destination = [0, 0]
var target = null
var aggro_range = 200
var attack_range = 50

func _init(bag).(bag):
    self.initial_position = Vector2(200, 200)
    self.velocity = 2

func go_to(x, y):
    self.destination[0] = x
    self.destination[1] = y

func process_ai():
    var distance
    var direction
    if self.target == null:
        for player in self.bag.players.players:
            if player.is_playing:
                distance = self.calculate_distance_to_object(player)
                if distance < self.aggro_range:
                    if self.target != null:
                        if self.calculate_distance_to_object(self.target) > distance:
                            self.target = player
                    else:
                        self.target = player
    else:
        distance = self.calculate_distance_to_object(self.target)
        if distance > self.attack_range:
            direction = self.cast_movement_vector(self.target.get_pos())
            self.movement_vector[0] = direction.x
            self.movement_vector[1] = direction.y

func cast_movement_vector(destination_point):
    var my_position = self.get_pos()
    var distance = self.calculate_distance(destination_point)
    var scale = 1.0 / distance
    var delta_x = (destination_point.x - my_position.x) * scale
    var delta_y = (destination_point.y - my_position.y) * scale

    return Vector2(delta_x, delta_y)

func process(delta):
    self.reset_movement()
    self.process_ai()
    self.modify_position()
