extends Control

func _ready() -> void:
	Globals.mouseFollower = self;

func _process(delta: float) -> void:
	var pos = get_global_mouse_position();
	position = pos;

func enablePlacementInputs(enabled: bool):
	$PlacementInputs.visible = enabled;
