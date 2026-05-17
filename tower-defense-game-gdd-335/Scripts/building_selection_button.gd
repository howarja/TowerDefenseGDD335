extends "res://Scripts/hoverButton.gd" 

@export var building: BuildingData;

func _ready() -> void:
	self.text = building.name;
	#self.connect("button_down", self._on_button_down());
	#self.connect("mouse_exited", _on_mouse_exited());
	
func _on_button_down():
	# This button was clicked, change selected tower
	Globals.playerManager.setSelectedBuilding(building);
	
func _on_mouse_entered():
	# don't let the player place if they are clicking on a button
	Globals.buildingInfo.enable(building, get_parent().position+position);
	mouseEntered();
	#print("mouse enterd");

func _on_mouse_exited():
	# let the player place because they aren't using a button anymore
	Globals.buildingInfo.disable();
	mouseExited(0);
	#print("mouse exited");
