extends Sprite2D

@onready var parent: Node2D = $".."


var pressing = false
@export var deadzone = 5
var control_area_size: Vector2  # Size of the control area (passed from parent)
var control_area_offset: Vector2  # Offset of the control area within the PNG

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize control area dimensions from parent
	control_area_size = parent.control_area_size * parent.scale.x
	control_area_offset = parent.control_area_offset * parent.scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressing:
		# Get the relative mouse position within the control area
		var local_mouse_pos = get_global_mouse_position() - parent.global_position - control_area_offset
		
		# Constrain the knob's movement to the control area
		local_mouse_pos.x = clamp(local_mouse_pos.x, 0, control_area_size.x)
		local_mouse_pos.y = clamp(local_mouse_pos.y, 0, control_area_size.y)
		
		# Update knob's global position
		global_position = local_mouse_pos + parent.global_position + control_area_offset
		
		# Calculate the output vector
		calculate_vector(local_mouse_pos)
	else:
		# Snap the knob to 100% clutch (x = control_area_size.x) and 0% throttle (y = control_area_size.y / 2)
		var snap_pos = Vector2(control_area_size.x, control_area_size.y / 2)
		
		# Update the global position to the snapped position
		global_position = snap_pos + parent.global_position + control_area_offset
		
		# Update the parent's posVector to reflect 100% clutch and 0% throttle
		parent.posVector.x = 1.0  # Clutch (100%)
		parent.posVector.y = 0.0  # Throttle (0%)
		
		parent.throttle = 0
		parent.clutch = 1
		parent.rear_brake = 0.0
		parent.front_brake = 0.0


func calculate_vector(local_mouse_pos: Vector2):
	# Normalize the local position to a range of -1 to 1 for both axes
	var normalized_pos = Vector2(
		(local_mouse_pos.x / control_area_size.x),
		(local_mouse_pos.y / control_area_size.y) * 2 - 1
	)
	
	# Top half: Throttle and Clutch
	if local_mouse_pos.y < control_area_size.y / 2:
		parent.posVector.x = normalized_pos.x  # Clutch
		parent.posVector.y = -normalized_pos.y  # Throttle (negative because up is positive)
	else:  # Bottom half: Braking
		parent.posVector.x = normalized_pos.x  # Front/rear brake balance
		parent.posVector.y = (normalized_pos.y + 1) / 2  # Braking amount (0 to 1)
	
	if local_mouse_pos.y < control_area_size.y / 2:
		parent.throttle = parent.posVector.y
		parent.clutch = parent.posVector.x
		parent.rear_brake = 0.0
		parent.front_brake = 0.0
		#print("throttle: ", parent.throttle, "clutch: ", parent.clutch)
	else:
		parent.throttle = 0.0
		parent.clutch = 1
		parent.rear_brake = parent.posVector.y
		parent.front_brake = parent.posVector.y * parent.posVector.x
		#print("rear_brake: ", parent.rear_brake, "front_brake: ", parent.front_brake)

func _on_button_button_down() -> void:
	pressing = true


func _on_button_button_up() -> void:
	pressing = false
