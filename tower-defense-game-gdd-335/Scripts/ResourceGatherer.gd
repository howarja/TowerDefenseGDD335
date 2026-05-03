extends "res://Scripts/building.gd"

@export var resourceGain: Resources;
@export var gainTime: float;
@onready var train: PackedScene = preload("res://Scenes/Towers/GoldGathererBuilding.tscn");
var currentCooldown: float = 1;

func _process(delta: float) -> void:
	currentCooldown -= delta;
	if currentCooldown <= 0:
		Globals.playerManager.addResources(resourceGain);
		currentCooldown = gainTime;
		spawnTrain();

func spawnTrain():
	var surroundings = getSurroundingTiles();
	for i in surroundings.size():
		if surroundings[i]!=null:
			if surroundings[i].is_in_group("TrainTracks"):
				var trainTrack = surroundings[i];
				var newTrain = train.instantiate();
				newTrain.position = trainTrack.position;
				Globals.level.add_child(newTrain);
				return;
