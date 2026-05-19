extends "res://Scripts/hoverButton.gd" 

var target;

func _ready() -> void:
	Globals.placedBuidlingInfo = self;
	setTarget(null);

func setTarget(newTarget):
	var validTarget: bool = (newTarget!=null);
	if target!=null:
		target.deselect();
	
	self.target = newTarget;
	visible = validTarget;
	if validTarget:
		target.select();
		$Panel/BuildingName.text = target.buildingName;

func _process(delta: float) -> void:
	if target != null:
		var pos = target.get_global_transform_with_canvas().origin;
		setPosition(pos);

func setPosition(pos: Vector2):
	position = pos;

func _on_sell_button_button_down() -> void:
	if target!= null:
		if target.getCanSell():
			target.sellBuilding();
			target.deselect();
			setTarget(null);

func _on_sell_button_mouse_entered() -> void:
	mouseEntered();

func _on_sell_button_mouse_exited() -> void:
	mouseExited(0.01);

func _on_repair_button_button_down() -> void:
	if target!= null:
		target.repair();

func _on_repair_button_mouse_entered() -> void:
	mouseEntered();

func _on_repair_button_mouse_exited() -> void:
	mouseExited(0.01);
