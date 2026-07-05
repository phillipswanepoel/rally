extends Resource
class_name MobData

@export var max_health: float = 100.0
@export var speed: float = 150.0
@export var attack_damage: float = 10.0

static func create(p_max_health: float, p_speed: float, p_attack_damage: float) -> MobData:
	var mob_data = MobData.new()
	mob_data.max_health = p_max_health
	mob_data.speed = p_speed
	mob_data.attack_damage = p_attack_damage
	return mob_data
