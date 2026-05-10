extends Node2D

@onready var enemy = preload("res://Scenes/Enemies/enemy.tscn");
var enemySpawnAmount: int = 2;
var spawnsPerWave: int = 5;
var remainingSpawns: int = 5;
var enemySpawnCooldown: float = 3;
var currentSpawnCooldown: float = 3;

var currentWave = 0;
var waveCooldown: float = 35;
var currentWaveCooldown: float = 0;
var waveCooldownIncrease: float = 15;
var maxWaveCooldown: float = 60;

var spawnDist: float = 3000;

var centralBuilding;

func _ready() -> void:
	currentWaveCooldown = waveCooldown;

func setCentralBuilding(newBuilding):
	# set the building for the enemies to target
	centralBuilding = newBuilding;

func _process(delta: float) -> void:
	# spawn a new enemy on a cooldown
	if currentWaveCooldown>0:
		currentWaveCooldown -= delta;
		if currentWaveCooldown<=0:
			newWave();
	else:
		currentSpawnCooldown -= delta;
		if currentSpawnCooldown <= 0 && centralBuilding!=null:
			remainingSpawns-=1;
			if remainingSpawns<=0:
				currentWaveCooldown = min(maxWaveCooldown ,waveCooldown+waveCooldownIncrease*currentWave);
				if currentWave%5==0 && currentWave<=30:
					Globals.level.growLevel(20);
			for i in enemySpawnAmount*currentWave:
				spawnEnemy();

func spawnEnemy():
	var newEnemy = enemy.instantiate(); 
	add_child(newEnemy);
	
	var newPos = centralBuilding.position+Vector2(randf()-0.5, randf()-0.5).normalized()*spawnDist;
	newEnemy.position = newPos;
	newEnemy.setTarget(centralBuilding);
	
	currentSpawnCooldown = enemySpawnCooldown/currentWave;

func newWave():
	currentWave+=1;
	remainingSpawns = spawnsPerWave * currentWave;
