extends Node2D

var posVector: Vector2

# Output values
var throttle = 0.0
var clutch = 0.0
var rear_brake = 0.0
var front_brake = 0.0

# Dimensions of the rectangular control area
@export var control_area_size: Vector2 = Vector2(200, 900)
@export var control_area_offset: Vector2 = Vector2(50, 50)  # Offset to position rectangle within the PNG
