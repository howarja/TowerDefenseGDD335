extends Node2D

var active: bool = false;

var maxHealth: float = 100;
var currentHealth: float = 100;
@onready var healthBar = $HealthBar;

var dir: Vector2i = Vector2.UP;

func damage(amount: float):
	# lower the health of this tower, queueFree if tower has no health
	currentHealth -= amount;
	healthBar.setPercent(currentHealth/maxHealth);
	if currentHealth <= 0:
		queue_free();

func getGridPos():
	return Globals.level.convertToGridSpace(position);

func getSurroundingTiles():
	var selfGridPos: Vector2i = getGridPos();
	var tiles = [];
	tiles.append(Globals.level.getBuildingAt(selfGridPos+Vector2i.UP))
	tiles.append(Globals.level.getBuildingAt(selfGridPos+Vector2i.DOWN))
	tiles.append(Globals.level.getBuildingAt(selfGridPos+Vector2i.RIGHT))
	tiles.append(Globals.level.getBuildingAt(selfGridPos+Vector2i.LEFT))
	print(tiles);
	return tiles;
	
func getGroundTile():
	var selfGridPos: Vector2i = getGridPos();
	return Globals.level.getBuildingAt(selfGridPos);
	
func enable():
	active = true;
	var rot = rotation - deg_to_rad(90);
	var newDir = Vector2(cos(rot), sin(rot));
	dir = newDir.normalized();
