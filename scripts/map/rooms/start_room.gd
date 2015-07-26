extends "res://scripts/map/rooms/abstract_room.gd"

func _init():
    self.room = [
        [ 4,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  6],
        [ 7,  1,  0,  0,  0,  8,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  9],
        [ 7,  2,  0,  0,  0,  1,  2,  0,  0,  0,  1,  0,  0,  0,  1,  0,  9],
        [ 7,  0,  1,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  2,  0,  0,  9],
        [ 7,  0,  0,  2,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  2,  0,  9],
        [ 7,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  9],
        [ 7,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  2,  0,  0,  0,  0,  9],
        [ 7,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  9],
        [ 7,  0,  0,  0,  0,  8,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  9],
        [ 7,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  9],
        [12, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11],
    ]
    self.enemies = [
        [3, 3, 'retarded_rat'],
        [3, 5, 'retarded_rat'],
        [3, 6, 'retarded_rat'],
        [3, 7, 'jumping_rat'],
        [3, 8, 'fat_rat'],
    ]
    self.items = [
        [13, 5, 'cheese'],
        [12, 5, 'medicals']
    ]