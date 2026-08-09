extends Node2D

@export var spawn_interval: float = 5.0
@export var mob_type: MobDatabase.MobType
var spawning: bool = false
@export var team: int = 1

func _on_spawn_timer_timeout() -> void:
	if spawning:
		spawn_mob(mob_type)

func _ready() -> void:
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)

# TODO: minimum bound from spawner size/rect
func _on_button_pressed() -> void:
	create_rally_line()

func create_rally_line() -> void:
	var rally_line = RallyLine.new()
	rally_line.rally_set.connect(_on_rally_set)
	# TODO: change to sibling
	add_child(rally_line)

@onready var rally_marker := $RallyMarker
func _on_rally_set(p: Vector2) -> void:
	rally_marker.global_position = p
	rally_marker.visible = true
	spawning = true
	$SpawnTimer.start(spawn_interval)

# TODO: make mob not child of spawner
@onready var mobs := $Mobs
func spawn_mob(type: MobDatabase.MobType) -> void:
	var new_mob: Mob = Mob.create(type)
	new_mob.position = position
	new_mob.team = team
	if rally_marker:
		new_mob.rally_target = rally_marker.global_position
	mobs.add_child(new_mob)
