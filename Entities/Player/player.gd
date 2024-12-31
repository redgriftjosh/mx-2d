extends RigidBody2D

var wheels = []
var speed = 6000
var max_speed = 97.4 # km/h Gear 1 = 32.5 Gear 2 = 47.6, Gear 3 = 64.2, Gear 4 = 82.1, Gear 5 = 97.4
var throttle = 0.0  # Current throttle value from BikeSpeedControl
var max_hp = 59
var max_rpm = 10000  # Maximum engine RPM
var base_torque = 15.0  # Base torque at 100% throttle

# Engine sounds
@onready var engine_sound: AudioStreamPlayer2D = $EngineSound
@onready var bike_speed_control: Node2D = $"../CanvasLayer/Joystick"

func _ready():
	wheels = get_tree().get_nodes_in_group("rear_wheel")

func _physics_process(delta):
	# Get the throttle value from BikeSpeedControl
	throttle = bike_speed_control.throttle  # ranges from 0 - 1
	
	# Calculate effective horsepower based on throttle
	var effective_hp = max_hp * throttle
	var i = 0
	# Apply throttle to the wheels
	for wheel in wheels:
		if i > 0:
			break # rear wheel only lol do this better later
		i += 1
		# Calculate RPM as a percentage of max speed
		var speed_percent = abs(wheel.angular_velocity) / max_speed
		speed_percent = clamp(speed_percent, 0.0, 1.0)  # Clamp to 0-100%
		var rpm = speed_percent * max_rpm
		# Update engine sound
		engine_sound.update(rpm, throttle)
		
		# Calculate torque from effective HP
		var torque = (effective_hp * 5252) / max(rpm, 600)
		print("Speed: ", round(wheel.angular_velocity * 100) / 100, " rpm: ", round(rpm * 100) / 100, " throttle: ", round(throttle * 10) / 10, " torque: ", round(torque))		
		if throttle > 0.0 and wheel.angular_velocity < max_speed:
			wheel.apply_torque_impulse(throttle * speed * delta * 60)
		elif throttle < 0.0 and wheel.angular_velocity > -max_speed:
			wheel.apply_torque_impulse(throttle * speed * delta * 60)
