extends Node2D

@export var gridX: int = 30;
@export var gridY: int = 30;
var tiles = [];

@export var tileSize = 97;
@onready var tile = preload("res://Scenes/Towers/tile.tscn");
@onready var centralBuilding = preload("res://Scenes/Towers/centralBuilding.tscn");
@onready var enemyManger = $EnemyManager;

func _ready() -> void:
	# spawn a grid of tiles
	for x in range(gridX):
		tiles.append([]);
		for y in range(gridY):
			spawnOnGrid(x, y, tile);
			
	# replace the middle tile with the central building
	replaceTile(Vector2i(gridX/2, gridY/2), centralBuilding);
	enemyManger.setCentralBuilding(tiles[gridX/2][gridY/2]);

func replaceTile(position: Vector2i, toSpawn):
	# Replace the tile at given cooridnates with different given scene
	if position.x<gridX && position.x >= 0:
		if position.y < gridY && position.y >= 0:
			if tiles[position.x][position.y] != null:
				tiles[position.x][position.y].queue_free();
			tiles[position.x][position.y] = spawnOnGrid(position.x, position.y, toSpawn);

func spawnOnGrid(x: int, y: int, toSpawn):
	# Instantiate a scene at an X, Y positoins on the grid of the game
	var newTile = toSpawn.instantiate();
	add_child(newTile);
	tiles[x].append(newTile);
		
	newTile.position = Vector2(x*tileSize, y*tileSize);
	return newTile;

func placeBuilding(building):
	var mousePos = (get_global_mouse_position()+Vector2.ONE*tileSize/2)/tileSize;
	replaceTile(mousePos, building);
