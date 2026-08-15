extends Panel

func _ready() -> void:
	Globals.loseScreen = self;
	
func enable():
	show();
	$"Lose text".text = "[center]The slimes defeated you...\nYou reached wave "+str(Globals.enemyManager.getCurrentWave());

func _on_button_pressed() -> void:
	get_tree().paused = false;
	get_tree().reload_current_scene();
