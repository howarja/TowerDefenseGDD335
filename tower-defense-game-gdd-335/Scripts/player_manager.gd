extends Node2D

var resources: Resources = Resources.new();

@onready var level = $"..";
@onready var ui = $"../UI";

var interactable: bool = true;
var selectedBuilding: BuildingData;

func _ready() -> void:
	Globals.playerManager = self;
	ui.updateResourceText(resources);

func _input(event: InputEvent) -> void:
	# Spawn a building when the mouse is clicked
	if event.is_action_pressed("Primary") && selectedBuilding != null && interactable:
		if level.placeBuilding(selectedBuilding):
			addResources(selectedBuilding.cost);

func setSelectedBuilding(newSelection: BuildingData):
	selectedBuilding = newSelection;
	
func addResources(newResources: Resources):
	resources._costResources(newResources);
	ui.updateResourceText(resources);
	
func setInteractability(newInteractable: bool):
	interactable = newInteractable;
