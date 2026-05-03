extends Sprite2D

@onready var pivot = $Pivot;
@onready var background = $".";
@onready var fill = $Pivot/Fill;
@onready var visiblityTimer = $VisiblityTimer;
var maxScaleX: float;

var isVisible: bool = false;

func _ready() -> void:
	maxScaleX = pivot.scale.x;
	setVisiblity(false);

func setPercent(percent: float):
	pivot.scale = Vector2(maxScaleX*percent, pivot.scale.y);
	if percent < 1:
		setVisiblity(true);

func setVisiblity(visiblity: bool):
	background.visible = visiblity;
	fill.visible = visiblity
	isVisible = visiblity;
	if visiblity:
		visiblityTimer.start();

func _on_visiblity_timer_timeout() -> void:
	setVisiblity(false);
