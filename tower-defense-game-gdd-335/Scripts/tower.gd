extends "res://Scripts/building.gd"

@export var radius = 500;
var initialRadius;
@export var projectileSpeed: float = 5;
@export var projectileDamage: float = 5;

@onready var projectile = preload("res://Scenes/projectile.tscn");
@onready var turret = $Sprite2D/Turret;

@export var shootDelay: float = 1;
var currentShootDelay: float = 1;

@export var rangeUpgrade: float = 0;
@export var firerateUpgrade: float = 0;
@export var damageUpgrade: float = 0;

func _ready() -> void:
	super._ready();
	initialRadius = radius;

func _process(delta: float) -> void:
	if !active:
		return;

	var enemies = get_tree().get_nodes_in_group("Enemies");
	var bestDist = radius;
	var targetIndex = -1;
	for i in enemies.size():
		if position.distance_to(enemies[i].position)-enemies[i].getScale() < bestDist:
			targetIndex = i;
	if targetIndex >= 0:
		turret.look_at(enemies[targetIndex].position)
		if currentShootDelay <= 0:
			shoot(enemies[targetIndex].position - position);
			currentShootDelay = 1/shootDelay;
		else:
			currentShootDelay -= delta;

func shoot(dir: Vector2):
	var newBullet = projectile.instantiate();
	newBullet.setUp(projectileSpeed, dir, projectileDamage);
	get_parent().add_child(newBullet);
	newBullet.position = position;

func upgrade():
	super.upgrade();
	projectileDamage+=damageUpgrade;
	shootDelay += firerateUpgrade;
	radius+=rangeUpgrade;
	interactedSprite.scale = Vector2.ONE * radius/initialRadius;
