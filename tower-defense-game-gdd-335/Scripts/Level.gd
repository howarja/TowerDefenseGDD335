extends Node2D

@export var gridX: int = 30;
@export var gridY: int = 30;
var tiles = [];
var ground = []

@export var tileSize = 97;
@onready var tile = preload("res://Scenes/Towers/tile.tscn");
@onready var oreDeposit = preload("res://Scenes/Towers/oreDeposit.tscn");
@onready var centralBuilding = preload("res://Scenes/Towers/centralBuilding.tscn");
@onready var enemyManger = $EnemyManager;

func _ready() -> void:
	# spawn a grid of tiles
	for x in range(gridX):
		tiles.append([]);
		ground.append([]);
		for y in range(gridY):
			var toSpawn = tile;
			if y<gridY/2:
				toSpawn = oreDeposit;
			spawnOnGrid(x, y, toSpawn);
			
	# replace the middle tile with the central building
	replaceTile(Vector2i(gridX/2, gridY/2), centralBuilding);
	enemyManger.setCentralBuilding(tiles[gridX/2][gridY/2]);

func getGroundGroup(pos: Vector2, groupName: String):
	var gridPos: Vector2 = convertToGridSpace(pos);
	var groundTile = ground[gridPos.x][gridPos.y];
	if groundTile != null:
		return groundTile.is_in_group(groupName);
	else:
		return false;

func replaceTile(position: Vector2i, toSpawn):
	# Replace the tile at given cooridnates with different given scene
	if position.x<gridX && position.x >= 0:
		if position.y < gridY && position.y >= 0:
			if tiles[position.x][position.y] == null:
				#tiles[position.x][position.y].queue_free();
				tiles[position.x][position.y] = spawnOnGrid(position.x, position.y, toSpawn);

func spawnOnGrid(x: int, y: int, toSpawn):
	# Instantiate a scene at an X, Y positoins on the grid of the game
	var newTile = toSpawn.instantiate();
	add_child(newTile);
	tiles[x].append(null);
	ground[x].append(newTile);
	
	newTile.position = Vector2(x*tileSize, y*tileSize);
	return newTile;

func placeBuilding(building: BuildingData):
	var canPlace: bool = true;
	if building.requiredTileGroup != "":
		canPlace = false;
		if getGroundGroup(get_global_mouse_position(), building.requiredTileGroup):
			canPlace = true;
	if canPlace:
		var mousePos = convertToGridSpace(get_global_mouse_position());
		replaceTile(mousePos, building.buildingScene);
	return canPlace;
	
func convertToGridSpace(pos: Vector2):
	return (pos+Vector2.ONE*tileSize/2)/tileSize;
