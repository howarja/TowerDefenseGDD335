extends Node2D

@onready var enemy = preload("res://Scenes/Enemies/enemy.tscn");
@export var enemySpawnCooldown: float = 3;
var spawnDist: float = 1000;
var currentSpawnCooldown: float = 3;

var centralBuilding;

func setCentralBuilding(newBuilding):
	# set the building for the enemies to target
	centralBuilding = newBuilding;

func _process(delta: float) -> void:
	# spawn a new enemy on a cooldown
	currentSpawnCooldown -= delta;
	if currentSpawnCooldown <= 0:
		var newEnemy = enemy.instantiate(); 
		add_child(newEnemy);
		
		var newPos = Vector2(randf(), randf()).normalized()*spawnDist;
		newEnemy.position = newPos;
		newEnemy.setTarget(centralBuilding);
		
		currentSpawnCooldown = enemySpawnCooldown;
