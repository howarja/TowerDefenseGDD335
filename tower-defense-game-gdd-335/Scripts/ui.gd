extends CanvasLayer

func updateResourceText(resources: Resources):
	#var newText: String = "Iron: " + str(resources.iron) + "\nGold: " + str(resources.gold) + "\nCoal: " + str(resources.coal) + "\nWood" + str(resources.wood);
	var newText: String = "Gold: " + str(resources.gold);
	$Panel/ResourceText.text = newText;
