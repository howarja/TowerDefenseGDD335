extends "res://Scripts/building.gd"

@export var speed: float = 1;
@export var speedUpgrade: float = 0;

func getNextPos():
	var selfGridPos: Vector2i = getGridPos();
	return Globals.level.convertToWorldSpace(selfGridPos+dir);

func getSpeed():
	return 1/speed;
	
func upgrade():
	super.upgrade();
	speed+=speedUpgrade;
