extends CharacterBody2D

@export var speed: float = 5.0;
@export var damage: float = 5.0;
@export var damageCooldown: float = 0.1;
var currentDamageCooldown: float = 0;

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
				collision.damage(damage);
				currentDamageCooldown = damageCooldown;
			
	currentDamageCooldown -= delta;

func setTarget(newTarget):
	# set the target for the enemy to move towards
	target = newTarget;
