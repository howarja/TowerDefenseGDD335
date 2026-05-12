extends Control

var target;

func _ready() -> void:
	Globals.placedBuidlingInfo = self;

func setTarget(target):
	self.target = target;	

func _process(delta: float) -> void:
	if target != null:
		var pos = target.get_global_transform_with_canvas().origin;
		setPosition(pos);

func setPosition(pos: Vector2):
	position = pos;
