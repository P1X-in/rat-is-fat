
var bag
var camera

var zoom

var shake_timer
var shakes = 0
export var shakes_max = 5
export var shake_time = 0.25
export var shake_boundary = 5
var shake_initial_position
var temp_delta = 0
var pos

func _init_bag(bag):
    self.bag = bag
    self.camera = self.bag.root.camera
    self.zoom = self.camera.get_zoom()

func shake():
    shakes = 0
    shake_initial_position = self.camera.get_camera_pos()
    self.do_single_shake()

func do_single_shake():
    if shakes < shakes_max:
        var distance_x = randi() % shake_boundary
        var distance_y = randi() % shake_boundary
        if randf() <= 0.5:
            distance_x = -distance_x
        if randf() <= 0.5:
            distance_y = -distance_y

        pos = shake_initial_position + Vector2(distance_x, distance_y)
        self.camera.set_offset(pos)
        shakes += 1
        self.bag.timers.set_timeout(0.15, self, "do_single_shake")
    else:
        pos = shake_initial_position
        self.camera.set_offset(shake_initial_position)