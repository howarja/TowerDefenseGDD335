extends Node2D

var resources: Resources = Resources.new();

@onready var level = $"..";
@onready var ui = $"../UI";

var selectedBuilding: BuildingData;

func _ready() -> void:
	Globals.playerManager = self;
	ui.updateResourceText(resources);

func _input(event: InputEvent) -> void:
	# Spawn a building when the mouse is clicked
	if event.is_action_pressed("Primary") && selectedBuilding != null:
		level.placeBuilding(selectedBuilding.buildingScene);
		resources._costResources(selectedBuilding.cost);
		ui.updateResourceText(resources);

func setSelectedBuilding(newSelection: BuildingData):
	selectedBuilding = newSelection;
