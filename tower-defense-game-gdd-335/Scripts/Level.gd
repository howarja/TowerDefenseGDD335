extends Node2D

@export var gridX: int = 30;
@export var gridY: int = 30;

@export var tileSize = 97;
@onready var tile = preload("res://Scenes/Towers/tile.tscn");

var tiles = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(gridX):
		tiles.append([]);
		for y in range(gridY):
			var newTile = tile.instantiate();
			add_child(newTile);
			tiles[x].append(newTile);
			
			newTile.position = Vector2(x*tileSize, y*tileSize);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		pass;
