extends CharacterBody2D

var speed: float = 5;
var dir: Vector2;
var damage: float = 1;

func _physics_process(delta: float) -> void:
	velocity = dir * speed;
	move_and_slide();
	
	# damage any enemies this projectile touches, destroy self on any collision
	for i in get_slide_collision_count():
		var kinematicCollision = get_slide_collision(i);
		var collision = kinematicCollision.get_collider();
		if collision.is_in_group("Enemies"):
			collision.damage(damage);
			queue_free();

func setUp(newSpeed: float, newDir: Vector2, newDamage: float):
	speed = newSpeed;
	dir = newDir;
	damage = newDamage;
