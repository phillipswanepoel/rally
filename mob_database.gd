extends Resource
class_name MobDatabase

enum MobType {
	SOLDIER,
	ROGUE,
	WIZARD
}

static var database: Dictionary[MobType, MobData] = {
	MobType.SOLDIER: MobData.create(50.0, 15.0, 10.0),
	MobType.ROGUE: MobData.create(40.0, 25.0, 5.0),
	MobType.WIZARD: MobData.create(30.0, 10.0, 15.0)
}
