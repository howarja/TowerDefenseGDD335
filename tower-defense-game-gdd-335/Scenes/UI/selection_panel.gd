extends "res://Scripts/hoverButton.gd" 

var targets = [];

func _ready() -> void:
	Globals.selectedBuildingInfo = self;
	setTarget(null);

func setTarget(newTargets):
	var validTarget: bool = (newTargets!=null)&&(newTargets.size()>0);
	if targets!=null:
		deselect();
	
	self.targets = newTargets;
	visible = validTarget;
	if validTarget:
		select();
		setButtonText();
		$TitleText.text = "Selected: " + str(targets.size()) + " buildings";

func setButtonText():
	var totalSell: int = 0;
	for i in targets.size():
		if targets[i]!=null:
			if targets[i].getCanSell():
				totalSell+=targets[i].getSellValue().gold;
	$SellButton.text = "Sell: +" + str(totalSell)+" Gold";
	$SellButton.visible = (totalSell!=0);
	
	var totalRepair: int = 0;
	for i in targets.size():
		if targets[i]!=null:
			if targets[i].getCanSell():
				totalRepair+=targets[i].getRepairCost().gold;
	$RepairButton.text = "Repair: " + str(totalRepair)+" Gold";
	$RepairButton.visible = (totalRepair!=0);
	
	var totalUpgrade: int = 0;
	for i in targets.size():
		if targets[i]!=null:
			totalUpgrade+=targets[i].getUpgradeCost().gold;
	$UpgradeButton.text = "Upgrade: " + str(totalUpgrade)+" Gold";
	$UpgradeButton.visible = (totalUpgrade!=0);

func deselect():
	for i in targets.size():
		if targets[i]!=null:
			targets[i].deselect();

func select():
	for i in targets.size():
		if targets[i]!=null:
			targets[i].select();

func setPosition(pos: Vector2):
	position = pos;

func _on_sell_button_button_down() -> void:
	if targets!= null:
		for i in targets.size():
			if targets[i]!=null:
				if targets[i].getCanSell():
					targets[i].sellBuilding();
					targets[i].deselect();
	setTarget(null);

func _on_sell_button_mouse_entered() -> void:
	mouseEntered();

func _on_sell_button_mouse_exited() -> void:
	mouseExited(0.01);

func _on_repair_button_button_down() -> void:
	if targets != null:
		var totalRepair: Resources = Resources.new();
		for i in targets.size():
			if targets[i]!=null:
				totalRepair.addResources(targets[i].getRepairCost());
		
		if Globals.playerManager.resourceCostCheck(totalRepair):
			if targets != null:
				for i in targets.size():
					if targets[i]!=null:
						targets[i].repair();
	setButtonText();

func _on_repair_button_mouse_entered() -> void:
	mouseEntered();

func _on_repair_button_mouse_exited() -> void:
	mouseExited(0.01);

func _on_upgrade_button_mouse_entered() -> void:
	mouseEntered();

func _on_upgrade_button_mouse_exited() -> void:
	mouseExited(0.01);

func _on_upgrade_button_button_down() -> void:
	if targets != null:
		var totalUpgrade: Resources = Resources.new();
		for i in targets.size():
			if targets[i]!=null:
				totalUpgrade.addResources(targets[i].getUpgradeCost());
		
		if Globals.playerManager.resourceCostCheck(totalUpgrade):
			for i in targets.size():
				if targets[i]!=null:
					targets[i].canUpgrade();
	setButtonText();
