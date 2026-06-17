extends Node2D

@export var enemies: Array[enemyData];

@export var levelIncreasePerWave: int = 30;
@export var enemySpawnAmount: int = 2;
@export var weightPerWave: int = 2;
var remainingWeight: int = 2;
@export var enemySpawnCooldown: float = 3;
var currentSpawnCooldown: float = 3;

var currentWave = 0;
@export var waveCooldown: float = 35;
var currentWaveCooldown: float = 0;
@export var waveCooldownIncrease: float = 15;
@export var maxWaveCooldown: float = 60;

@export var bosses: Array[enemyData];
@export var bossWaves: Array[int];
var currentBoss: int = 0;

var spawnDist: float = 3000;

var centralBuilding;
@onready var ui = $"../UI";

func _ready() -> void:
	currentWaveCooldown = waveCooldown;

func setCentralBuilding(newBuilding):
	# set the building for the enemies to target
	centralBuilding = newBuilding;

func _process(delta: float) -> void:
	# spawn a new enemy on a cooldown
	if currentWaveCooldown>0:
		currentWaveCooldown -= delta;
		ui.updateWaveTimerText(currentWaveCooldown, currentWave);
		if currentWaveCooldown<=0:
			newWave();
	else:
		if currentWave == bossWaves[min(bossWaves.size(), currentBoss)]:
			spawnBoss();
			endWave();
		else:
			currentSpawnCooldown -= delta;
			if currentSpawnCooldown <= 0 && centralBuilding!=null:
				if remainingWeight<=0:
					endWave();
				for i in enemySpawnAmount*currentWave:
					spawnRandomEnemy();

func endWave():
	currentWaveCooldown = min(maxWaveCooldown ,waveCooldown+waveCooldownIncrease*currentWave);
	if currentWave%5==0 && currentWave<=30:
		Globals.level.growLevel(levelIncreasePerWave);
func spawnBoss():
	spawnEnemy(bosses[min(bosses.size()-1, currentBoss)])
	currentBoss+=1;

func spawnRandomEnemy():
	var chosenEnemyData = chooseEnemy();
	spawnEnemy(chosenEnemyData);
	currentSpawnCooldown = enemySpawnCooldown/currentWave;

func spawnEnemy(chosenEnemyData: enemyData):
	var newEnemy = chosenEnemyData.scene.instantiate();
	add_child(newEnemy);
	
	var newPos = centralBuilding.position+Vector2(randf()-0.5, randf()-0.5).normalized()*spawnDist;
	newEnemy.position = newPos;
	newEnemy.setTarget(centralBuilding);

func chooseEnemy():
	# firstly loop through all avalible enemies and add up their cances
	var cumalitave: float = 0;
	for i in enemies.size():
		cumalitave += calculateChance(enemies[i]);
		
	# choose a random number between 0 and total of all chances
	var rand = randf()*cumalitave;
	
	# loop through again but stop once cumilation is greater than the random number
	var newCumalitive: float = 0;
	for i in enemies.size():
		var pastWaves = currentWave - enemies[i].minWaves;
		if pastWaves>=0:
			newCumalitive += calculateChance(enemies[i]);
			if newCumalitive>=rand:
				remainingWeight-=enemies[i].weight;
				return enemies[i];

func calculateChance(enemy: enemyData):
	var pastWaves = currentWave - enemy.minWaves;
	if pastWaves>=0:
		var currentChance = enemy.initialChance + enemy.chanceChangePerWave*pastWaves;
		currentChance = min(max(currentChance, enemy.minMaxChancePercent.x),enemy.minMaxChancePercent.y)
		return currentChance;
	else:
		return 0;

func newWave():
	currentWave+=1;
	remainingWeight = weightPerWave * currentWave;
