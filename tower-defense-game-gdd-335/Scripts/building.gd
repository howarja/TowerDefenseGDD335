extends Node2D

var maxHealth: float = 100;
var currentHealth: float = 100;
@onready var healthBar = $HealthBar;

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
	tiles.append(Globals.level.getTileAt(selfGridPos+Vector2i.UP))
	tiles.append(Globals.level.getTileAt(selfGridPos+Vector2i.DOWN))
	tiles.append(Globals.level.getTileAt(selfGridPos+Vector2i.RIGHT))
	tiles.append(Globals.level.getTileAt(selfGridPos+Vector2i.LEFT))
	return tiles;
