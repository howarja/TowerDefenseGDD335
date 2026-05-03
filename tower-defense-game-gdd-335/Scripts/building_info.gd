extends Panel

@onready var text = $RichTextLabel;

func _ready() -> void:
	Globals.buildingInfo = self;

func enable(building: BuildingData, pos: Vector2):
	visible = true;
	position = pos-pivot_offset;
	var nameText: String = building.name+":\n"+building.description;
	var costText: String = "\n\nIron: "+str(building.cost.iron)+"\nGold: "+str(building.cost.gold)+"\nCoal: "+str(building.cost.coal)+"\nWood: "+str(building.cost.wood);
	var finalText: String = nameText+costText;
	text.text = finalText;
		
func disable():
	visible = false;
