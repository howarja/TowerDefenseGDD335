extends Node2D

@export var gridX: int = 30;
@export var gridY: int = 30;
var offset: int = 0;

var buildings = [];
var ground = []
var trains = [];

@export var tileSize = 97;
@export var oreDepositCount: int = 18;
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
	
	# replace the middle tile with the central building
	centralBuilding = replaceTile(Vector2i(gridX/2, gridY/2), centralBuildingPackedScene, false);
	centralBuilding.enable();
	enemyManger.setCentralBuilding(buildings[gridX/2][gridY/2]);
	
	var oreDepositPositions = [];
	for i in oreDepositCount:
		var newPos = Vector2i(randf_range(0,gridX), randf_range(0,gridY));
		replaceTile(newPos, oreDeposit, true);
		
	growLevel(20);
	#growLevel(2);

func getGroundGroup(pos: Vector2, groupName: String):
	var groundTile = getGroundTileAt(pos, false)
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

func growLevel(amount: int):
	# firstly make sure amount is an even number
	if amount%2!=0:
		amount += 1;
	
	var newBuildings = [];
	var newGround = [];
	var newTrainTracks = [];

	var x: int = 0;
	var y: int = 0;
	var newOffset: int = offset - amount/2;
	#print("Total increase: "+str(gridX) +" to " + str(gridX+amount));
	#print(str(x) + " to " + str(gridX+amount) + " : " + str(gridX+amount-1+newOffset) + " to " + str(gridX));
	while x < gridX+amount+abs(offset):
		newBuildings.append([]);
		newGround.append([]);
		newTrainTracks.append([]);
		var spawnX = x+newOffset;
		y = 0;
		while y < gridY+amount+abs(offset):
			var spawnY = y+newOffset;
			if spawnX < offset or spawnY < offset or spawnX >= gridX or spawnY >= gridY:
				var toSpawn = tile;
				if randf()>0.95:
					toSpawn = oreDeposit;
				var newTile = spawnOnGrid(spawnX, spawnY, toSpawn);
				
				newBuildings[x].append(null);
				newGround[x].append(newTile);
				newTrainTracks[x].append(null); 
			else:
				newBuildings[x].append(getBuildingAt(Vector2i(spawnX,spawnY),false));
				newGround[x].append(getGroundTileAt(Vector2i(spawnX,spawnY),false));
				if getGroundGroup(Vector2i(spawnX,spawnY),"OreDeposits"):
					print("Found ore: " + str(x) + ", " + str(y));
				newTrainTracks[x].append(getTrainAt(Vector2i(spawnY,spawnY),false));
			y+=1;
		x+=1;
	
	offset = newOffset;
	gridX+=amount/2;
	gridY+=amount/2;
	buildings = newBuildings;
	ground = newGround;
	trains = newTrainTracks;

func spawnOnGrid(x: int, y: int, toSpawn):
	# Instantiate a scene at an X, Y positoins on the grid of the game
	var newTile = toSpawn.instantiate();
	add_child(newTile);
	
	newTile.position = Vector2(x*tileSize, y*tileSize);
	return newTile;
	
func canPlaceAt(pos: Vector2,building: BuildingData):
	var gridPos = convertToGridSpace(pos);
	var canPlace: bool = true;

	if !withinLevel(gridPos):
		#print("Outside level bounds");
		return false;
	elif getBuildingAt(gridPos,false)!=null:
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

func getBuildingAt(pos: Vector2i, applyOffset: bool):
	if applyOffset:
		pos = applyOffset(pos);
	if(!withinLevel(pos)):
		return null;
	return buildings[pos.x][pos.y];

func getGroundTileAt(pos: Vector2i, applyOffset: bool):
	if applyOffset:
		pos = applyOffset(pos);
	print(pos);
	if(!withinLevel(pos)):
		print("Outside level");
		return null;
	return ground[pos.x][pos.y];

func getTrainAt(pos: Vector2i, applyOffset: bool):
	if applyOffset:
		pos = applyOffset(pos);
	if(!withinLevel(pos)):
		return null;
	return trains[pos.x][pos.y];

func withinLevel(pos: Vector2i):
	#pos = applyOffset(pos);
	if pos.x>=ground.size() or pos.x<0:
		return false;
	if pos.y>=ground[pos.x].size() or pos.y<0:
		return false;
	return true;
	
func applyOffset(pos: Vector2i):
	return pos-Vector2i.ONE*offset;

func setBuildingAt(pos: Vector2i, building):
	pos = applyOffset(pos);
	buildings[pos.x][pos.y] = building;

func setTrainAt(pos: Vector2i, train):
	pos = applyOffset(pos);
	trains[pos.x][pos.y] = train;
