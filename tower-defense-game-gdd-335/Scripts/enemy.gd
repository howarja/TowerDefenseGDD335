extends CharacterBody2D

@export var speed: float = 5.0;
@export var damageDeal: float = 5.0;
@export var damageCooldown: float = 0.1;
@export var deathParticles: GPUParticles2D;
var currentDamageCooldown: float = 0;

@export var maxHealth: float = 100;
var currentHealth: float = 100;
@onready var healthBar = $HealthBar;

@export var cornerDistance: float = 15;

var target;

func _ready() -> void:
	currentHealth = maxHealth;

func addStrength(mult: float):
	#speed+=addition;
	damageDeal*=mult;
	maxHealth*=mult;
	currentHealth = maxHealth;
	scale*=Vector2.ONE*mult;

func _physics_process(delta: float) -> void:
	# move toward the target
	var vel = Vector2.ZERO;
	if target!=null:
		vel = (target.position - position).normalized()*speed;
	velocity = vel;
	move_and_slide();
	
	# damage any buildings this enemy touches
	var damaged: bool = false;
	for i in get_slide_collision_count():
		var kinematicCollision = get_slide_collision(i);
		var collision = kinematicCollision.get_collider();
		if collision.is_in_group("Buildings"):
			if currentDamageCooldown <= 0:
				collision.damage(damageDeal);
				damaged = true;
	if damaged:
		currentDamageCooldown = damageCooldown;
	
	currentDamageCooldown -= delta;

func setTarget(newTarget):
	# set the target for the enemy to move towards
	target = newTarget;

func damage(amount: float):
	# lower the health of this tower, queueFree if tower has no health
	currentHealth -= amount;
	healthBar.setPercent(currentHealth/maxHealth);
	deathParticles.emitting = true;
	if currentHealth <= 0:
		healthBar.setVisiblity(false, false);
		queue_free();

func getScale():
	return cornerDistance;
	
func changeHealthBar(newHealthBar):
	newHealthBar.setVisiblity(false, true);
	self.healthBar = newHealthBar;
	newHealthBar.setVisiblity(true, false);
