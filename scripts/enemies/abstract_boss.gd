extends "res://scripts/enemies/abstract_enemy.gd"

var phase = 1
var difficulty = 2

var phase_hp_thresholds = []

func _init(bag).(bag):
    self.bag = bag

func process(delta):
    .process(delta)
    self.check_change_phase()

func check_change_phase():
    for threshold in self.phase_hp_thresholds:
        if self.hp < threshold[0] && self.phase < threshold[1]:
            self.enter_phase(threshold[1])

func enter_phase(num):
    self.phase = num
    self.call("phase" + str(num))

func phase1():
    return