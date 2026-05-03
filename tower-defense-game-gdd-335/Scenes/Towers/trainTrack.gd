extends "res://Scripts/building.gd"

var dir: Vector2i = Vector2i(0,1);

func getNextPos():
	var selfGridPos: Vector2i = getGridPos();
	return Globals.level.convertToWorldSpace(selfGridPos);
