extends Node2D
class_name Mob

@export var mob_type: MobDatabase.MobType

var stats: MobData
var current_health: float
var current_target: Vector2

func _ready() -> void:
	add_to_group("mobs")
	initialize_stats()

func initialize_stats() -> void:
	stats = MobDatabase.database[mob_type].duplicate()
	current_health = stats.max_health

static func create(p_type: MobDatabase.MobType) -> Mob:
	var scene = load("res://mob.tscn")
	var mob = scene.instantiate() as Mob
	mob.mob_type = p_type
	return mob

func _process(delta: float) -> void:
	if current_target:
		global_position = global_position.move_toward(current_target, stats.speed * delta * 10)
