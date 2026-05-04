extends Node2D

var resources: Resources = Resources.new();

@onready var ui = $"../UI";

var interactable: bool = true;
var selectedBuilding: BuildingData;
var currentSelectedInstance;
var currentRot = 0;

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

func _input(event: InputEvent) -> void:
	# Spawn a building when the mouse is clicked
	if event.is_action_pressed("Primary") && currentSelectedInstance != null && interactable:
		var canPlace: bool = Globals.level.canPlaceAt(currentSelectedInstance.position, selectedBuilding);
		if canPlace:
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

func addResources(newResources: Resources):
	resources.addResources(newResources);
	ui.updateResourceText(resources);

func setInteractability(newInteractable: bool):
	interactable = newInteractable;
