extends "res://Scripts/hoverButton.gd" 

var target;

func _ready() -> void:
	Globals.placedBuidlingInfo = self;
	setTarget(null);

func setTarget(target):
	self.target = target;
	visible = (target!=null);

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
			setTarget(null);

func _on_sell_button_mouse_entered() -> void:
	mouseEntered();

func _on_sell_button_mouse_exited() -> void:
	mouseExited(0.01);
