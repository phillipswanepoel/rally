extends Node2D

# TODO: minimum bound from spawner size/rect
func _on_button_pressed() -> void:
	create_rally_line()

func create_rally_line() -> void:
	var rally_line = RallyLine.new(position)
	rally_line.rally_set.connect(_on_rally_set)
	add_child(rally_line)

@onready var rally_marker := $RallyMarker
@onready var rally_path := $RallyPath

func _on_rally_set(p: Vector2) -> void:
	rally_marker.position = p
	rally_marker.visible = true

	var c := Curve2D.new()
	c.add_point(position)
	c.add_point(p)
	rally_path.curve = c
