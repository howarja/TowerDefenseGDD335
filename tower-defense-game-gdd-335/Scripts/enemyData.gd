extends Resources
class_name enemyData

@export var enemyName: String;
@export var scene: PackedScene;
@export var minWaves: int = 0;
@export var initialChance: int = 100;
@export var chanceChangePerWave: float = 5;# in percent
@export var minMaxChancePercent: Vector2 = Vector2(1,100);
@export var weight: float = 1;
