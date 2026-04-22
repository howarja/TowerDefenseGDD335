extends Node2D

var maxHealth: float = 100;
var currentHealth: float = maxHealth;

func damage(amount: float):
	currentHealth -= amount;
	if currentHealth <= 0:
		queue_free();
