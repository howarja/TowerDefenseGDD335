extends Button

func _ready() -> void:
	Globals.enemyManager.waveComplete.connect(showSelf);

func showSelf():
	show();

func _on_button_down() -> void:
	Globals.enemyManager.newWave();
	hide();
