extends Node2D

@export var gridX: int = 30;
@export var gridY: int = 30;

var buildings = [];
var ground = []
var trains = [];

@export var tileSize = 97;
@export var oreDepositCount: int = 8;
@onready var tile = preload("res://Scenes/Towers/tile.tscn");
@onready var oreDeposit = preload("res://Scenes/Towers/oreDeposit.tscn");
@onready var centralBuildingPackedScene = preload("res://Scenes/Towers/centralBuilding.tscn");
@onready var enemyManger = $EnemyManager;

var centralBuilding;

func _ready() -> void:
	# spawn a grid of tiles
	Globals.level = self;
	for x in range(gridX):
		buildings.append([]);
		ground.append([]);
		trains.append([]);
		for y in range(gridY):
			var toSpawn = tile;
			spawnOnGrid(x, y, toSpawn);
	
	# replace the middle tile with the central building
	replaceTile(Vector2i(gridX/2, gridY/2), centralBuildingPackedScene, false);
	enemyManger.setCentralBuilding(buildings[gridX/2][gridY/2]);
	
	var oreDepositPositions = [];
	for i in oreDepositCount:
		var newPos = Vector2i(randf_range(0,gridX), randf_range(0,gridY));
		replaceTile(newPos, oreDeposit, true);

func getGroundGroup(pos: Vector2, groupName: String):
	var gridPos: Vector2i = convertToGridSpace(pos);
	var groundTile = getGroundTileAt(gridPos)
	if groundTile != null:
		return groundTile.is_in_group(groupName);
	else:
		return false;

func replaceTile(position: Vector2i, toSpawn, groundTile: bool):
	# Replace the tile at given cooridnates with different given scene
	if position.x<gridX && position.x >= 0:
		if position.y < gridY && position.y >= 0:
			if buildings[position.x][position.y] == null:
				var newTile = spawnOnGrid(position.x, position.y, toSpawn);
				if groundTile:
					ground[position.x][position.y] = newTile;
				else:
					buildings[position.x][position.y] = newTile;

func spawnOnGrid(x: int, y: int, toSpawn):
	# Instantiate a scene at an X, Y positoins on the grid of the game
	var newTile = toSpawn.instantiate();
	add_child(newTile);
	buildings[x].append(null);
	trains[x].append(null);
	ground[x].append(newTile);
	
	newTile.position = Vector2(x*tileSize, y*tileSize);
	return newTile;

#func placeBuilding(building: BuildingData):
	#var canPlace: bool = true;
	#if building.requiredTileGroup != "":
		#canPlace = false;
		#if getGroundGroup(get_global_mouse_position(), building.requiredTileGroup):
			#canPlace = true;
	#if canPlace:
		#var mousePos = convertToGridSpace(get_global_mouse_position());
		#replaceTile(mousePos, building.buildingScene, false);
	#return canPlace;
	
func canPlaceAt(pos: Vector2,building: BuildingData):
	var gridPos = convertToGridSpace(pos);
	var canPlace: bool = true;
	
	if gridPos.x>=gridX or gridPos.x<=0:
		return false;
	elif gridPos.y>=gridY or gridPos.y<=0:
		return false;
	elif getBuildingAt(gridPos)!=null:
		canPlace = false;
	elif building.requiredTileGroup != "":
		canPlace = false;
		if getGroundGroup(get_global_mouse_position(), building.requiredTileGroup): 
			canPlace = true;

	return canPlace; 

func convertToGridSpace(pos: Vector2i):
	return (pos+Vector2i.ONE*tileSize/2)/tileSize;

func convertToWorldSpace(pos: Vector2i):
	return Vector2(pos.x, pos.y)*tileSize;

func getBuildingAt(pos: Vector2i):
	if pos.x>=buildings.size() or pos.x<0:
		return null;
	if pos.y>=buildings[pos.x].size() or pos.y<0:
		return null;
	return buildings[pos.x][pos.y];

func getGroundTileAt(pos: Vector2i):
	if pos.x>=ground.size() or pos.x<0:
		return null;
	if pos.y>=ground[pos.x].size() or pos.y<0:
		return null;
	return ground[pos.x][pos.y];
	
func getTrainAt(pos: Vector2i):
	if pos.x>=trains.size() or pos.x<0:
		return null;
	if pos.y>=trains[pos.x].size() or pos.y<0:
		return null;
	return trains[pos.x][pos.y];

func setBuildingAt(pos: Vector2i, building):
	buildings[pos.x][pos.y] = building;

func setTrainAt(pos: Vector2i, train):
	trains[pos.x][pos.y] = train;
