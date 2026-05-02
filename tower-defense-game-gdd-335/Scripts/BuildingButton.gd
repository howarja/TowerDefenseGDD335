extends Button

@export var selectedBuilding: BuildingData;

func _on_pressed() -> void:
	Globals.playerManager.setSelectedBuilding(selectedBuilding);
