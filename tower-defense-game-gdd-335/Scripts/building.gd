extends Node2D

var buildingName: String = "";
var active: bool = false;
var resourceValue: Resources;

@export var maxHealth: float = 100;
var currentHealth: float = 100;
@onready var healthBar = $HealthBar;
@onready var collision = $CollisionShape2D;
@onready var sprite: Node2D = $Sprite2D;

var dir: Vector2i = Vector2.UP;
var spriteScale

func _ready() -> void:
	$CollisionShape2D.disabled = true;
	spriteScale = sprite.scale;
	sprite.scale /= 1.5;
	currentHealth = maxHealth;

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
	tiles.append(Globals.level.getBuildingAt(selfGridPos+Vector2i.UP))
	tiles.append(Globals.level.getBuildingAt(selfGridPos+Vector2i.DOWN))
	tiles.append(Globals.level.getBuildingAt(selfGridPos+Vector2i.RIGHT))
	tiles.append(Globals.level.getBuildingAt(selfGridPos+Vector2i.LEFT))
	return tiles;

func getGroundTile():
	var selfGridPos: Vector2i = getGridPos();
	return Globals.level.getBuildingAt(selfGridPos);

func enable(value: Resources, newName: String):
	active = true;
	buildingName = newName;
	var rot = rotation - deg_to_rad(90);
	var newDir = Vector2(cos(rot), sin(rot));
	dir = newDir.normalized();
	$CollisionShape2D.disabled = false;
	setColor(Color.WHITE);
	var tween = get_tree().create_tween();
	tween.tween_property(sprite, "scale", spriteScale, 0.1).set_trans(Tween.TRANS_BOUNCE)
	
	if value != null:
		resourceValue = Resources.absResources(value);

func setColor(col: Color):
	sprite.self_modulate = col;

func select():
	healthBar.setVisiblity(true, false);

func deselect():
	healthBar.setVisiblity(false, false);

func getCanSell():
	return resourceValue!=null;

func sellBuilding():
	Globals.playerManager.addResources(Resources.divideResrouces(resourceValue, 2));
	queue_free();

func repair():
	var healthPercent: float = currentHealth/maxHealth;
	if healthPercent<=0.99:
		var repairResources: Resources = Resources.divideResrouces(resourceValue, 1/healthPercent)
		if Globals.playerManager.resourceCostCheck(repairResources):
			Globals.playerManager.subtractResources(repairResources);
			currentHealth = maxHealth;
			healthBar.setPercent(currentHealth/maxHealth);
