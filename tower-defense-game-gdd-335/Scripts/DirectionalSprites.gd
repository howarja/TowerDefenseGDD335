extends Sprite2D

@export var sprites: Array[Texture2D];

func _ready() -> void:
	findSprite();

func _process(delta: float) -> void:
	findSprite();

func findSprite():
	var degreePerSprite = 360/sprites.size();
	var offset = degreePerSprite/2;
	var rot = get_parent().global_rotation_degrees+offset;
	while rot>360:
		rot-=360;
	var spriteIndex = floor(rot/degreePerSprite);
	texture = sprites[spriteIndex];
	global_rotation_degrees = 0;
