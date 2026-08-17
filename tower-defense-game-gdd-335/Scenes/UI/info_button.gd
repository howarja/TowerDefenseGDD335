extends Button

@export var toggle : Control;

func _on_button_down() -> void:
	toggle.visible = !toggle.visible;
