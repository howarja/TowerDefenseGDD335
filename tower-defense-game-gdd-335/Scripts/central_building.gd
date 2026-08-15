extends "res://Scripts/building.gd"

func damage(amount: float):
	# lower the health of this tower, queueFree if tower has no health
	currentHealth -= amount;
	healthBar.setPercent(currentHealth/maxHealth);
	if currentHealth <= 0:
		Globals.LoseScreen();
		queue_free();

func getUpgradeCost(): return Resources.new()

func canUpgrade(): pass;
