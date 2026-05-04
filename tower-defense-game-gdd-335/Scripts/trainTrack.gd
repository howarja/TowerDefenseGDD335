extends "res://Scripts/building.gd"

func getNextPos():
	var selfGridPos: Vector2i = getGridPos();
	return Globals.level.convertToWorldSpace(selfGridPos+dir);
