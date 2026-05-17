extends Control
class_name hoverButton

func mouseEntered():
	# don't let the player place if they are clicking on a button
	Globals.playerManager.setInteractability(false);

func mouseExited(delay: float):
	# let the player place because they aren't using a button anymore
	await get_tree().create_timer(delay).timeout# probably the worst solution possible
	Globals.playerManager.setInteractability(true);
