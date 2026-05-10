extends Node2D

var resources: Resources = Resources.new();

@onready var ui = $"../UI";

var interactable: bool = true;
var selectedBuilding: BuildingData;
var currentSelectedInstance;
var currentRot = 0;

@export var disabledCol: Color;
@export var enabledCol: Color;

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
	
	# Spawn a building when the mouse is clicked
	if currentSelectedInstance!=null:
		var canPlace: bool = Globals.level.canPlaceAt(currentSelectedInstance.position, selectedBuilding) && resourceCostCheck(selectedBuilding.cost);
		if canPlace:
			currentSelectedInstance.setColor(enabledCol);
		else:
			currentSelectedInstance.setColor(disabledCol);
		
		if Input.is_action_pressed("Primary") && interactable && canPlace:
			addResources(selectedBuilding.cost);
			var gridPos = Globals.level.convertToGridSpace(currentSelectedInstance.position);
			Globals.level.setBuildingAt(gridPos, currentSelectedInstance);
			currentSelectedInstance.enable();
			newBuilding();

func setSelectedBuilding(newSelection: BuildingData):
	selectedBuilding = newSelection;
	if currentSelectedInstance!=null:
		currentSelectedInstance.queue_free();
	newBuilding();
	
func newBuilding():
	currentSelectedInstance = selectedBuilding.buildingScene.instantiate();
	Globals.level.add_child(currentSelectedInstance);
	currentSelectedInstance.rotation=currentRot;

func resourceCostCheck(cost: Resources):
	var newResource: Resources = Resources.new();
	newResource.setResources(resources);
	newResource.addResources(cost);
	return newResource.aboveZero();

func addResources(newResources: Resources):
	resources.addResources(newResources);
	ui.updateResourceText(resources);

func setInteractability(newInteractable: bool):
	interactable = newInteractable;
