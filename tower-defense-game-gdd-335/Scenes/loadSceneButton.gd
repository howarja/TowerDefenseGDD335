extends Button

@export var newScenePath : String;

func _on_pressed() -> void:
	get_tree().change_scene_to_file(newScenePath);
