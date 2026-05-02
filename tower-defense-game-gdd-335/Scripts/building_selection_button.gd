extends Button

@export var building: BuildingData;

func _on_button_down() -> void:
	# This button was clicked, change selected tower
	Globals.playerManager.setSelectedBuilding(building);

func _on_mouse_entered() -> void:
	# don't let the player place if they are clicking on a button
	Globals.playerManager.setInteractability(false);

func _on_mouse_exited() -> void:
	# let the player place because they aren't using a button anymore
	Globals.playerManager.setInteractability(true);
