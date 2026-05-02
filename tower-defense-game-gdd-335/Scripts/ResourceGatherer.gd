extends "res://Scripts/building.gd"

@export var resourceGain: Resources;
@export var gainTime: float;
var currentCooldown: float = 1;

func _process(delta: float) -> void:
	currentCooldown -= delta;
	if currentCooldown <= 0:
		Globals.playerManager.addResources(resourceGain);
		currentCooldown = gainTime;
