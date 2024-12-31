extends AudioStreamPlayer2D

# The sample I have claims rpm is 5k when pitch = 1

# Engine parameters
var idle_rpm = 625
var max_rpm = 10000
var min_pitch = 0.125  # Pitch at idle RPM
var max_pitch = 2.0    # Pitch at max RPM
var min_volume = -10.0  # Minimum volume (idle throttle)
var max_volume = 0.0    # Maximum volume (full throttle)

# Function to update engine sound
func update(rpm: float, throttle: float):
	# Clamp RPM to idle and max values
	rpm = clamp(rpm, idle_rpm, max_rpm)
	throttle = clamp(throttle, 0.0, 1.0)  # Normalize throttle to 0.0 - 1.0

	# Map RPM to pitch scale
	var pitch_scale = lerp(min_pitch, max_pitch, (rpm - idle_rpm) / (max_rpm - idle_rpm))

	# Map throttle to volume in dB
	var volume_db = lerp(min_volume, max_volume, throttle)

	# Apply pitch and volume
	self.pitch_scale = pitch_scale
	self.volume_db = volume_db

	# Ensure the sound is playing
	if not is_playing():
		play()
