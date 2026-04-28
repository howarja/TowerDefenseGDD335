extends Button

@export var building: BuildingData;

func _on_button_down() -> void:
	Globals.playerManager.setSelectedBuilding(building);
