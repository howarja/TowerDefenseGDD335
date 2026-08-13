extends AnimationPlayer

func _ready() -> void:
	Globals.enemyManager.waveBegin.connect(playAnim);
	$newWavePanel/Text.text = "[center]Wave: " + str(Globals.enemyManager.getCurrentWave()+1);
	
func playAnim():
	play("NewWave")
