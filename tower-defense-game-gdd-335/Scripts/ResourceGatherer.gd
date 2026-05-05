extends "res://Scripts/building.gd"

@export var resourceGain: Resources;
@export var gainTime: float;
@export var requiresTrain: bool = true;
@onready var train: PackedScene = preload("res://Scenes/Towers/Train.tscn");
var currentCooldown: float = 1;

func _process(delta: float) -> void:
	if !active:
		return;
	
	currentCooldown -= delta;
	if currentCooldown <= 0:
		currentCooldown = gainTime;
		spawnTrain();

func spawnTrain():
	if requiresTrain:
		var surroundings = getSurroundingTiles();
		for i in surroundings.size():
			if surroundings[i]!=null:
				if surroundings[i].is_in_group("TrainTracks"):
					var trainTrack = surroundings[i];
					var newTrain = train.instantiate();
					newTrain.position = trainTrack.position;
					newTrain.setResources(resourceGain);
					Globals.level.add_child(newTrain);
					return;
	else:
		Globals.playerManager.addResources(resourceGain);
