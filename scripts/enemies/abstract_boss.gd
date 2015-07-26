extends "res://scripts/enemies/abstract_enemy.gd"

var phase = 1

func process(delta):
    .process(delta)
    self.check_change_phase()

func check_change_phase():
    return

func enter_phase(num):
    self.phase = num
    self.call("phase" + str(num))

func phase1():
    return