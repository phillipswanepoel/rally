extends Line2D
class_name RallyLine

signal rally_set(pos: Vector2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("MouseLeft"):
		rally_set.emit(get_global_mouse_position())
		queue_free()


func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position() - global_position
	points[-1] = mouse_pos


# func _init(start_pos: Vector2) -> void:
# 	var p: PackedVector2Array = PackedVector2Array()
# 	p.push_back(start_pos)
# 	p.push_back(start_pos)
# 	points = p

func _init() -> void:
	var p: PackedVector2Array = PackedVector2Array()
	p.push_back(Vector2.ZERO)
	p.push_back(Vector2.ZERO)
	points = p
