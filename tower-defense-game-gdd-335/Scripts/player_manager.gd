extends Node2D

var resources: Resources = Resources.new();

@onready var ui = $"../UI";

var interactable: bool = true;
var selectedBuilding: BuildingData;
var currentSelectedInstance;
var currentRot = 0;

@export var disabledCol: Color;
@export var enabledCol: Color;

var selecting: bool = false;
var intitalSelectionPos: Vector2;
@onready var selectionDisplay = $SelectionDisplay;

func _ready() -> void:
	Globals.playerManager = self;
	ui.updateResourceText(resources);

func _process(delta: float) -> void:
	if currentSelectedInstance!=null:
		var gridPos = Globals.level.convertToGridSpace(get_global_mouse_position());
		var worldPos = Globals.level.convertToWorldSpace(gridPos);
		currentSelectedInstance.position = worldPos;
		if Input.is_action_just_pressed("Rotate"):
			currentRot+=deg_to_rad(90);
			currentSelectedInstance.rotation=currentRot;
		elif Input.is_action_just_pressed("Deselect"):
			currentSelectedInstance.queue_free();
			currentSelectedInstance = null;
			Globals.mouseFollower.enablePlacementInputs(false);
	
	# Spawn a building when the mouse is clicked
	if currentSelectedInstance!=null:
		var canPlace: bool = Globals.level.canPlaceAt(currentSelectedInstance.position, selectedBuilding) && resourceCostCheck(selectedBuilding.cost);
		if canPlace:
			currentSelectedInstance.setColor(enabledCol);
		else:
			currentSelectedInstance.setColor(disabledCol);
		
		if Input.is_action_pressed("Primary") && canPlace && interactable:
			addResources(selectedBuilding.cost);
			var gridPos = Globals.level.convertToGridSpace(currentSelectedInstance.position);
			Globals.level.setBuildingAt(gridPos, currentSelectedInstance);
			currentSelectedInstance.enable(selectedBuilding.cost, selectedBuilding.name);
			newBuilding();
	elif interactable:
		if Input.is_action_pressed("Primary") && !selecting:
			selecting = true;
			intitalSelectionPos = get_global_mouse_position();
			selectionDisplay.show();
		elif Input.is_action_just_released("Primary") && selecting:
			selecting = false;
			selectRange(intitalSelectionPos, get_global_mouse_position())
	setPolygon();


func setPolygon():
	if selecting:
		var lastPos = Globals.level.convertToWorldSpace(Globals.level.convertToGridSpace(get_global_mouse_position()));
		var firstPos = Globals.level.convertToWorldSpace(Globals.level.convertToGridSpace(intitalSelectionPos));
		var closeX = min(firstPos.x,lastPos.x)-100;
		var closeY = min(firstPos.y,lastPos.y)-100;
		var farX = max(firstPos.x,lastPos.x);
		var farY = max(firstPos.y,lastPos.y);
		selectionDisplay.polygon[0]= Vector2(closeX,closeY);
		selectionDisplay.polygon[1] = Vector2(farX,closeY);
		selectionDisplay.polygon[2] = Vector2(farX,farY);
		selectionDisplay.polygon[3] = Vector2(closeX,farY);

func selectRange(pos1: Vector2, pos2: Vector2):
	pos1 = Globals.level.convertToGridSpace(pos1);
	pos2 = Globals.level.convertToGridSpace(pos2);
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
	
	selectBuilding(totalSelection);
	selectionDisplay.visible = (totalSelection.size()>0);

func setSelectedBuilding(newSelection: BuildingData):
	selectedBuilding = newSelection;
	if currentSelectedInstance!=null:
		currentSelectedInstance.queue_free();
	newBuilding();

func selectBuilding(building):
	Globals.selectedBuildingInfo.setTarget(building);
	selectionDisplay.visible = (building!=null);

func newBuilding():
	currentSelectedInstance = selectedBuilding.buildingScene.instantiate();
	Globals.level.add_child(currentSelectedInstance);
	currentSelectedInstance.rotation=currentRot;
	selectBuilding(null);
	Globals.mouseFollower.enablePlacementInputs(true);

func resourceCostCheck(cost: Resources):
	var newResource: Resources = Resources.new();
	newResource.setResources(resources);
	newResource.addResources(cost);
	return newResource.aboveZero();

func addResources(newResources: Resources):
	resources.addResources(newResources);
	ui.updateResourceText(resources);

func subtractResources(newResources: Resources):
	resources.subtractResources(newResources);
	ui.updateResourceText(resources);

func setInteractability(newInteractable: bool):
	interactable = newInteractable;
