extends CharacterBody2D
class_name Mob

@export var mob_type: MobDatabase.MobType
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var stats: MobData
var current_health: float
var current_target: Vector2

func _ready() -> void:
	add_to_group("mobs")
	initialize_stats()
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	navigation_agent.target_position = current_target

func initialize_stats() -> void:
	stats = MobDatabase.database[mob_type].duplicate()
	current_health = stats.max_health

static func create(p_type: MobDatabase.MobType) -> Mob:
	var scene = load("res://mob.tscn")
	var mob = scene.instantiate() as Mob
	mob.mob_type = p_type
	return mob

func _physics_process(delta: float) -> void:
	# if current_target:
	# 	global_position = global_position.move_toward(current_target, stats.speed * delta * 10)
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity = current_agent_position.direction_to(next_path_position) * stats.speed * delta * 800
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	# look_at(next_path_position)
	move_and_slide()
