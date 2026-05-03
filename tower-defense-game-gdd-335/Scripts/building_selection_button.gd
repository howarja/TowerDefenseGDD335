extends Button

@export var building: BuildingData;

func _ready() -> void:
	text = building.name;

func _on_button_down() -> void:
	# This button was clicked, change selected tower
	Globals.playerManager.setSelectedBuilding(building);

func _on_mouse_entered() -> void:
	# don't let the player place if they are clicking on a button
	Globals.playerManager.setInteractability(false);
	Globals.buildingInfo.enable(building, get_parent().position+position);

func _on_mouse_exited() -> void:
	# let the player place because they aren't using a button anymore
	Globals.playerManager.setInteractability(true);
	Globals.buildingInfo.disable();
