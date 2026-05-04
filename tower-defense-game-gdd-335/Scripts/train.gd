extends "res://Scripts/building.gd"

@onready var movementTimer = $MovementTimer;

func _on_movement_timer_timeout() -> void:
	var pos: Vector2i = getGridPos();
	var track = Globals.level.getBuildingAt(pos);
	
	var moved: bool = false;
	if track!=null:
		if track.is_in_group("TrainTracks"):
			var nextPos = track.getNextPos();
			position = track.getNextPos();
			moved = true;
		
