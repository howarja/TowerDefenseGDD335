extends Sprite2D

@onready var pivot = $Pivot;
@onready var background = $".";
@onready var fill = $Pivot/Fill;
@onready var visiblityTimer = $VisiblityTimer;
var yOffset: int = 80;
var maxScaleX: float;

var isVisible: bool = false;

func _ready() -> void:
	maxScaleX = pivot.scale.x;
	setVisiblity(false, true);

func setPercent(percent: float):
	pivot.scale = Vector2(maxScaleX*percent, pivot.scale.y);
	if percent < 1:
		setVisiblity(true, true);

func setVisiblity(visiblity: bool, disapear: bool):
	background.visible = visiblity;
	fill.visible = visiblity
	isVisible = visiblity;
	if disapear:
		if visiblity:
			visiblityTimer.start();
	else:
		visiblityTimer.stop();
	positionOnHead();

func positionOnHead():
	global_position = get_parent().global_position + Vector2.UP*yOffset;
	global_rotation = 0;

func _on_visiblity_timer_timeout() -> void:
	setVisiblity(false, true);
