extends Node2D

var maxHealth: float = 100;
var currentHealth: float = 100;

func damage(amount: float):
	# lower the health of this tower, queueFree if tower has no health
	currentHealth -= amount;
	if currentHealth <= 0:
		queue_free();
