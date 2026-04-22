extends CharacterBody2D

@export var speed: float = 5.0;
@export var damage: float = 5.0;
@export var damageCooldown: float = 0.1;
var currentDamageCooldown: float = 0;

var target: Vector2 = Vector2.ZERO;

func _physics_process(delta: float) -> void:
	var vel = (target - position).normalized()*speed;
	velocity = vel;
	move_and_slide();
	
	for i in get_slide_collision_count():
		var kinematicCollision = get_slide_collision(i);
		var collision = kinematicCollision.get_collider();
		if collision.is_in_group("Buildings"):
			if currentDamageCooldown <= 0:
				collision.damage(damage);
				currentDamageCooldown = damageCooldown;
			
	currentDamageCooldown -= delta;
