extends "res://Scripts/building.gd"

@onready var movementTimer = $MovementTimer;
var resources: Resources;

func _ready() -> void:
	var track = getTrack();
	if track!=null:
		if track.is_in_group("TrainTracks"):
			movementTimer.wait_time = track.getSpeed();
	movementTimer.start();
	
func getTrack():
	var pos: Vector2i = getGridPos();
	var track = Globals.level.getBuildingAt(pos);
	return track;
	
func _on_movement_timer_timeout() -> void:
	var track = getTrack();
	
	if track!=null:
		if track.is_in_group("TrainTracks"):
			movementTimer.wait_time = track.getSpeed();
			var tween = get_tree().create_tween();
			tween.tween_property(self, "position", track.getNextPos(), movementTimer.wait_time*0.6)
		elif track==Globals.level.centralBuilding:
			Globals.playerManager.addResources(resources);
			queue_free();
		else:
			queue_free();
	else:
		queue_free();

func setResources(newResources: Resources):
	resources = newResources;
