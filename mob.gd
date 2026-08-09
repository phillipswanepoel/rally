extends CharacterBody2D
class_name Mob

@export var mob_type: MobDatabase.MobType
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var detection_range: Area2D = $DetectionRange
@onready var team: int:
	set(t):
		team = t
		set_collision_layer_value(1, false)
		set_collision_layer_value(t, true)

		modulate = team_colors.get_or_add(t, Color.WHITE)
	get:
		return team


var stats: MobData
var current_health: float
var rally_target: Vector2
var team_colors: Dictionary[int, Color] = {
	1: Color.RED,
	2: Color.BLUE,
	3: Color.GREEN,
	4: Color.YELLOW,
}

func _ready() -> void:
	add_to_group("mobs")
	initialize_stats()
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 6.0
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

	for i in range(1, 5):
		detection_range.set_collision_mask_value(i, true)
	detection_range.set_collision_mask_value(team, false)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	navigation_agent.target_position = rally_target

	navigation_agent.set_avoidance_layer_value(1, false)
	navigation_agent.set_avoidance_layer_value(team, true)
	navigation_agent.set_avoidance_mask_value(1, false)
	navigation_agent.set_avoidance_mask_value(team, true)


func initialize_stats() -> void:
	stats = MobDatabase.database[mob_type].duplicate()
	current_health = stats.max_health

static func create(p_type: MobDatabase.MobType) -> Mob:
	var scene = load("res://mob.tscn")
	var mob = scene.instantiate() as Mob
	mob.mob_type = p_type
	return mob

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return

	if current_enemy_target:
		navigation_agent.target_position = current_enemy_target.global_position
		move_towards(current_enemy_target.global_position)
	else:
		move_towards(global_position)

func move_towards(target: Vector2) -> void:
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity = target.direction_to(next_path_position) * stats.speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	# look_at(next_path_position)
	move_and_slide()

# Enemy targeting
func shoot(target: Mob) -> void:
	pass

func die() -> void:
	$CollisionShape2D.disabled = true

func select_enemy() -> void:
	if enemy_targets:
		var enemies: Array[Mob] = enemy_targets.values()
		enemies.sort_custom(func(a, b):
			return a.global_position.distance_to(global_position) > b.global_position.distance_to(global_position))
		var winner: Mob = enemies[0]
		current_enemy_target = winner
		navigation_agent.target_position = winner.global_position
	else:
		current_enemy_target = null
		navigation_agent.target_position = rally_target


var enemy_targets: Dictionary[int, Mob] = {}
var current_enemy_target: Mob = null
func _on_detected(body: Node2D) -> void:
	if body is Mob:
		if body.team != team:
			enemy_targets.set(body.get_instance_id(), body)
			select_enemy()

func _on_vanished(body: Node2D) -> void:
	if body is Mob:
		if body.team != team:
			enemy_targets.erase(body.get_instance_id())
			select_enemy()
