extends HSlider

@export var yOffset: int = 80;
var maxScaleX: float;

var isVisible: bool = false;

func _ready() -> void:
	setVisiblity(false, false);
	Globals.bossHealthBar = self;

func setPercent(percent: float):
	value = percent;

func setVisiblity(visiblity: bool, disapear: bool):
	visible = visiblity;
	isVisible = visiblity;
	
func setName(name: String):
	$BossName.text = name;
