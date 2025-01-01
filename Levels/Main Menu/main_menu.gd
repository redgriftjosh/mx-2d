extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Level 1/level_1.tscn")


func _on_track_builder_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/Track Builder/track_builder.tscn")


func _on_temp_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/temp/temp.tscn")
