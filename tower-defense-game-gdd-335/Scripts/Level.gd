extends Node2D

@export var gridX: int = 30;
@export var gridY: int = 30;

@export var tileSize = 97;
@onready var tile = preload("res://Scenes/Towers/tile.tscn");
@onready var emptyTower = preload("res://Scenes/Towers/empty_tower.tscn");

var tiles = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(gridX):
		tiles.append([]);
		for y in range(gridY):
			spawnOnGrid(x, y, tile);

func replaceTile(position: Vector2i):
	if position.x<gridX && position.x >= 0:
		if position.y < gridY && position.y >= 0:
			if tiles[position.x][position.y] != null:
				tiles[position.x][position.y].queue_free();
			tiles[position.x][position.y] = spawnOnGrid(position.x, position.y, emptyTower);

func spawnOnGrid(x: int, y: int, toSpawn):
	var newTile = toSpawn.instantiate();
	add_child(newTile);
	tiles[x].append(newTile);
		
	newTile.position = Vector2(x*tileSize, y*tileSize);
	return newTile;

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Primary"):
		var mousePos = (get_global_mouse_position()+Vector2.ONE*tileSize/2)/tileSize;
		replaceTile(mousePos);
