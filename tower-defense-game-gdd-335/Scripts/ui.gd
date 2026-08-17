extends CanvasLayer

@onready var buildingSelectionButtons = [$BoxContainer/BuildingSelectionButton, $BoxContainer/BuildingSelectionButton2, $BoxContainer/BuildingSelectionButton4, $BoxContainer/BuildingSelectionButton5];

func updateResourceText(resources: Resources):
	#var newText: String = "Iron: " + str(resources.iron) + "\nGold: " + str(resources.gold) + "\nCoal: " + str(resources.coal) + "\nWood" + str(resources.wood);
	var newText: String = "Gold: " + str(resources.gold);
	$Goldcounter/ResourceText.text = newText;
	
func updateWaveTimerText(newTime: int, currentWave: int):
	pass;
	#$Panel2/WaveTimer.text = "Wave "+str(currentWave+1)+" in " +str(newTime);

func hideBuildingSelection(buildingType : BuildingData):
	for i in buildingSelectionButtons.size():
		if buildingSelectionButtons[i].getBuildingData==buildingType:
			buildingSelectionButtons[i].hide();
			return;

func showBuildingSelection(buildingType : BuildingData):
	for i in buildingSelectionButtons.size():
		if buildingSelectionButtons[i].getBuildingData==buildingType:
			buildingSelectionButtons[i].show();
			return;

func showAllBuildingSelection():
	for i in buildingSelectionButtons.size():
		buildingSelectionButtons[i].show();
		
func hideAllBuildingSelection():
	for i in buildingSelectionButtons.size():
		buildingSelectionButtons[i].show();
