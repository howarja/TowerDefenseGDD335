extends "res://Scripts/building.gd"

@export var radius = 500;
@onready var range = $Area2D;

@onready var projectile = preload("res://Scenes/projectile.tscn");

@export var shootDelay: float = 1;
var currentShootDelay: float = 1;

func _process(delta: float) -> void:
	if currentShootDelay <= 0:
		var enemies = get_tree().get_nodes_in_group("Enemies");
		var bestDist = 0;
		var targetIndex = -1;
		for i in enemies.size():
			if position.distance_to(enemies[i]) < bestDist:
				targetIndex = i;
		if targetIndex >= 0:
			shoot(enemies[targetIndex].position - position);
	else:
		currentShootDelay -= delta;
		
func shoot(dir: Vector2):
	var newBullet = projectile.instantiate();
	get_parent().add_child(newBullet);
	newBullet.position = position;
