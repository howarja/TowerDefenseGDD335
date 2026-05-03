extends Node2D

@export var gridX: int = 30;
@export var gridY: int = 30;
var tiles = [];
var ground = []

@export var tileSize = 97;
@export var oreDepositCount: int = 8;
@onready var tile = preload("res://Scenes/Towers/tile.tscn");
@onready var oreDeposit = preload("res://Scenes/Towers/oreDeposit.tscn");
@onready var centralBuilding = preload("res://Scenes/Towers/centralBuilding.tscn");
@onready var enemyManger = $EnemyManager;

func _ready() -> void:
	# spawn a grid of tiles
	Globals.level = self;
	for x in range(gridX):
		tiles.append([]);
		ground.append([]);
		for y in range(gridY):
			var toSpawn = tile;
			spawnOnGrid(x, y, toSpawn);
	
	# replace the middle tile with the central building
	replaceTile(Vector2i(gridX/2, gridY/2), centralBuilding, false);
	enemyManger.setCentralBuilding(tiles[gridX/2][gridY/2]);
	
	var oreDepositPositions = [];
	for i in oreDepositCount:
		var newPos = Vector2i(randf_range(0,gridX), randf_range(0,gridY));
		replaceTile(newPos, oreDeposit, true);

func getGroundGroup(pos: Vector2, groupName: String):
	var gridPos: Vector2 = convertToGridSpace(pos);
	var groundTile = ground[gridPos.x][gridPos.y];
	if groundTile != null:
		return groundTile.is_in_group(groupName);
	else:
		return false;

func replaceTile(position: Vector2i, toSpawn, groundTile: bool):
	# Replace the tile at given cooridnates with different given scene
	if position.x<gridX && position.x >= 0:
		if position.y < gridY && position.y >= 0:
			if tiles[position.x][position.y] == null:
				var newTile = spawnOnGrid(position.x, position.y, toSpawn);
				if groundTile:
					ground[position.x][position.y] = newTile;
				else:
					tiles[position.x][position.y] = newTile;

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
		replaceTile(mousePos, building.buildingScene, false);
	return canPlace;

func convertToGridSpace(pos: Vector2):
	return (pos+Vector2.ONE*tileSize/2)/tileSize;
	
func convertToWorldSpace(pos: Vector2i):
		return (pos-Vector2.ONE*tileSize/2)*tileSize;
		
func getTileAt(pos: Vector2i):
	return tiles[pos.x][pos.y];
