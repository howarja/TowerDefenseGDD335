extends AnimationPlayer

func _ready() -> void:
	Globals.enemyManager.waveBegin.connect(startAnim);
	Globals.enemyManager.waveComplete.connect(endAnim);
	
	
func startAnim():
	$newWavePanel/Text.text = "[center]Wave: " + str(Globals.enemyManager.getCurrentWave()+1);
	play("NewWave")

func endAnim():
	$newWavePanel/Text.text = "[center]Wave won!";
	play("waveComplete")
