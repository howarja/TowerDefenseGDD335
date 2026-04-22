extends Camera2D

var targetZoom: float = 1.0;
const MIN_ZOOM: float = 0.1;
const MAX_ZOOM: float = 3.0;
const ZOOM_INCREMENT: float = 0.1;
const ZOOM_RATE: float = 8.0;
const ZOOM_MOVE_MULTIPLIER: float = 1.0;

func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, targetZoom * Vector2.ONE, ZOOM_RATE * delta);

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT:
			position -= event.relative / (zoom*ZOOM_MOVE_MULTIPLIER);
			
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoomIn();
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoomOut();

func zoomIn() -> void:
	targetZoom = min(targetZoom + ZOOM_INCREMENT, MAX_ZOOM);
	set_physics_process(true);
	
func zoomOut() -> void:
	targetZoom = max(targetZoom - ZOOM_INCREMENT, MIN_ZOOM);
	set_physics_process(true);
