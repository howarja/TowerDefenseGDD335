extends Node2D

@export var gridX: int = 30;
@export var gridY: int = 30;
@export var intialSize: int = 20;

var visibleX: Vector2;
var visibleY: Vector2;

var buildings = [];
var ground = []
var trains = [];

@export var tileSize = 97;
@export var initialOreDepositCount: int = 18;
@export var totalOreDepositCount: int = 270;
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
			var newTile = spawnOnGrid(x, y, toSpawn);
			buildings[x].append(null);
			trains[x].append(null);
			ground[x].append(newTile);
	visibleX = Vector2(gridX/2-intialSize/2, gridX/2+intialSize/2);
	visibleY = Vector2(gridY/2-intialSize/2, gridY/2+intialSize/2);
	
	# replace the middle tile with the central building
	centralBuilding = replaceTile(Vector2i(gridX/2, gridY/2), centralBuildingPackedScene, false);
	centralBuilding.enable(null);
	$Camera2D.position = centralBuilding.position;
	enemyManger.setCentralBuilding(buildings[gridX/2][gridY/2]);
	
	# generate ore deposits
	var oreDepositPositions = [];
	for i in totalOreDepositCount:
		var newPos = Vector2i(randf_range(0,gridX), randf_range(0,gridY));
		replaceTile(newPos, oreDeposit, true);
	for i in initialOreDepositCount:
		var newPos = Vector2i(randf_range(visibleX.x,visibleX.y), randf_range(visibleY.x,visibleY.y));
		replaceTile(newPos, oreDeposit, true);
	setVisibility();


func setVisibility():
	for x in gridX:
		for y in gridY:
			if x<visibleX.x or x>visibleX.y or y<visibleY.x or y>visibleY.y:
				ground[x][y].hide();
			else:
				ground[x][y].show();

func growLevel(amount: int):
	if amount%2!=0:
		amount+=1;
	visibleX.x = max(0, visibleX.x-amount/2);
	visibleY.x = max(0, visibleY.x-amount/2);
	
	visibleX.y = min(gridX, visibleX.y+amount/2);
	visibleY.y = min(gridY, visibleY.y+amount/2);
	setVisibility();

func getGroundGroup(pos: Vector2, groupName: String):
	var groundTile = getGroundTileAt(pos)
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
				var prevTile = null;
				if groundTile:
					prevTile = ground[position.x][position.y];
					ground[position.x][position.y] = newTile;
				else:
					prevTile = buildings[position.x][position.y];
					buildings[position.x][position.y] = newTile;
				
				if prevTile!=null:
					prevTile.queue_free();
				return newTile;

func spawnOnGrid(x: int, y: int, toSpawn):
	# Instantiate a scene at an X, Y positoins on the grid of the game
	var newTile = toSpawn.instantiate();
	add_child(newTile);
	
	newTile.position = Vector2(x*tileSize, y*tileSize);
	return newTile;
	
func canPlaceAt(pos: Vector2,building: BuildingData):
	var gridPos = convertToGridSpace(pos);
	var canPlace: bool = true;

	if !withinLevel(gridPos) or !withinVisibleLevel(gridPos):
		#print("Outside level bounds");
		return false;
	elif getBuildingAt(gridPos)!=null:
		#print("Existing building");
		canPlace = false;
	elif building.requiredTileGroup != "":
		canPlace = false;
		if getGroundGroup(gridPos, building.requiredTileGroup): 
			canPlace = true;
		#else:
			#print("Incorrect ground tile");
	
	return canPlace;

func convertToGridSpace(pos: Vector2i):
	var posOffset = Vector2i.ONE;
	if pos.x<0:
		posOffset.x = -1;
	if pos.y<0:
		posOffset.y = -1;
	posOffset *= tileSize/2;
	return (pos+posOffset)/tileSize;
	
func convertToWorldSpace(pos: Vector2i):
	return Vector2(pos.x, pos.y)*tileSize;

func getBuildingAt(pos: Vector2i):
	if(!withinLevel(pos)):
		return null;
	return buildings[pos.x][pos.y];

func getGroundTileAt(pos: Vector2i):
	if(!withinLevel(pos)):
		return null;
	return ground[pos.x][pos.y];

func getTrainAt(pos: Vector2i):
	if(!withinLevel(pos)):
		return null;
	return trains[pos.x][pos.y];

func withinLevel(pos: Vector2i):
	if pos.x>=ground.size() or pos.x<0:
		return false;
	if pos.y>=ground[pos.x].size() or pos.y<0:
		return false;
	return true;

func withinVisibleLevel(pos: Vector2i):
	if pos.x>visibleX.y or pos.x<visibleX.x:
		return false;
	if pos.y>visibleY.y or pos.y<visibleY.x:
		return false;
	return true;

func setBuildingAt(pos: Vector2i, building):
	buildings[pos.x][pos.y] = building;

func setTrainAt(pos: Vector2i, train):
	trains[pos.x][pos.y] = train;
