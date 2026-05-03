extends CharacterBody2D

@export var speed: float = 5.0;
@export var damageDeal: float = 5.0;
@export var damageCooldown: float = 0.1;
var currentDamageCooldown: float = 0;

@export var maxHealth: float = 100;
var currentHealth: float = 100;
@onready var healthBar = $HealthBar;

var target;

func _physics_process(delta: float) -> void:
	# move toward the target
	var vel = Vector2.ZERO;
	if target!=null:
		vel = (target.position - position).normalized()*speed;
	velocity = vel;
	move_and_slide();
	
	# damage any buildings this enemy touches
	for i in get_slide_collision_count():
		var kinematicCollision = get_slide_collision(i);
		var collision = kinematicCollision.get_collider();
		if collision.is_in_group("Buildings"):
			if currentDamageCooldown <= 0:
				collision.damage(damageDeal);
				currentDamageCooldown = damageCooldown;
			
	currentDamageCooldown -= delta;

func setTarget(newTarget):
	# set the target for the enemy to move towards
	target = newTarget;
	
func damage(amount: float):
	# lower the health of this tower, queueFree if tower has no health
	currentHealth -= amount;
	healthBar.setPercent(currentHealth/maxHealth);
	if currentHealth <= 0:
		queue_free();
