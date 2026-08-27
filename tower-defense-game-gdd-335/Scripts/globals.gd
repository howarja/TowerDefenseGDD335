extends Node

var playerManager : playerManager;
var enemyManager;
var buildingInfo;
var level;
var mouseFollower;
var selectedBuildingInfo;
var bossHealthBar;
var loseScreen;

func LoseScreen():
	playerManager.disable();
	loseScreen.enable();
	get_tree().paused = true;
	pass;
