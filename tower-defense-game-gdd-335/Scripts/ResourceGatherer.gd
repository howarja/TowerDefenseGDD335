extends "res://Scripts/building.gd"

@export var resourceGain: Resources;
@export var gainTime: float = 1;
@export var maxGains: int = 5;
var currentGains: int = 0;

@export var requiresTrain: bool = true;
@onready var train: PackedScene = preload("res://Scenes/Towers/Train.tscn");
var currentCooldown: float = 1;

#@export var gainTimeUpgrade: float = 0;
var gainAmountMultiplier: float = 1;
@export var gainAmountUpgrade: float = 0.5;

var inWave: bool = false;

func _ready() -> void:
	super._ready();
	Globals.enemyManager.waveBegin.connect(resetGains);

func _process(delta: float) -> void:
	if !active || !Globals.enemyManager.getInWave():
		if currentGains<=0:
			return;
		else:
			currentCooldown-=delta*3;
	inWave = Globals.enemyManager.getInWave();
	
	if currentGains>0:
		currentCooldown -= delta;
		if currentCooldown <= 0:
			currentCooldown = 1/gainTime;
			spawnTrain();

func resetGains():
	currentGains = maxGains;

func spawnTrain():
	currentGains-=1;
	if requiresTrain:
		var surroundings = getSurroundingTiles();
		for i in surroundings.size():
			if surroundings[i]!=null:
				if surroundings[i].is_in_group("TrainTracks"):
					var trainTrack = surroundings[i];
					var newTrain = train.instantiate();
					newTrain.position = trainTrack.position;
					newTrain.setResources(Resources.multiplyResources(resourceGain, gainAmountMultiplier));
					Globals.level.add_child(newTrain);
					return;
	else:
		Globals.playerManager.addResources(resourceGain);

func upgrade():
	super.upgrade();
	gainAmountMultiplier+=gainAmountUpgrade;
