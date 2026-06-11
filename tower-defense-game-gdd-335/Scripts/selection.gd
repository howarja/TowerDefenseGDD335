class_name selection

@export var initialPos: Vector2;
@export var finalPos: Vector2;
var selectionDisplayScene = preload("res://Scenes/selection_display.tscn")
var selectionDisplay;

func beginSelection(pos: Vector2, playerManager):
	self.initialPos = pos;
	self.finalPos = pos;
	selectionDisplay = selectionDisplayScene.instantiate();
	playerManager.add_child(selectionDisplay);
	selectionDisplay.show();
	setPolygon();

func updateSelection(pos: Vector2):
	self.finalPos = pos;
	setPolygon();

func setPolygon():
	var lastPos = Globals.level.convertToWorldSpace(Globals.level.convertToGridSpace(finalPos));
	var firstPos = Globals.level.convertToWorldSpace(Globals.level.convertToGridSpace(initialPos));
	var closeX = min(firstPos.x,lastPos.x)-100;
	var closeY = min(firstPos.y,lastPos.y)-100;
	var farX = max(firstPos.x,lastPos.x);
	var farY = max(firstPos.y,lastPos.y);
	selectionDisplay.polygon[0]= Vector2(closeX,closeY);
	selectionDisplay.polygon[1] = Vector2(farX,closeY);
	selectionDisplay.polygon[2] = Vector2(farX,farY);
	selectionDisplay.polygon[3] = Vector2(closeX,farY);
	
func getSelection():
	var pos1 = Globals.level.convertToGridSpace(initialPos);
	var pos2 = Globals.level.convertToGridSpace(finalPos);
	var totalSelection = [];
	
	var x = min(pos1.x, pos2.x);
	while x <= max(pos1.x, pos2.x):
		var y = min(pos1.y, pos2.y);
		while y <= max(pos1.y, pos2.y):
			var building = Globals.level.getBuildingAt(Vector2i(x,y));
			if building!=null:
				totalSelection.append(building);
			y+=1;
		x+=1;

	selectionDisplay.visible = (totalSelection.size()>0);
	return totalSelection;

func endSelection():
	selectionDisplay.queue_free();
