extends "res://Scripts/building.gd"

@export var radius = 500;
@export var projectileSpeed: float = 5;
@export var projectileDamage: float = 5;

@onready var projectile = preload("res://Scenes/projectile.tscn");

@export var shootDelay: float = 1;
var currentShootDelay: float = 1;

func _process(delta: float) -> void:
	if currentShootDelay <= 0:
		var enemies = get_tree().get_nodes_in_group("Enemies");
		var bestDist = radius;
		var targetIndex = -1;
		for i in enemies.size():
			if position.distance_to(enemies[i].position) < bestDist:
				targetIndex = i;
		if targetIndex >= 0:
			shoot(enemies[targetIndex].position - position);
			currentShootDelay = shootDelay;
	else:
		currentShootDelay -= delta;
		
func shoot(dir: Vector2):
	var newBullet = projectile.instantiate();
	newBullet.setUp(projectileSpeed, dir, projectileDamage);
	get_parent().add_child(newBullet);
	newBullet.position = position;
