# Godot & GDScript Style Guide Quick Reference

Below is a quick reference table of the naming conventions recommended by the official [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_style_guide.html).

| Category | Style | Examples |
| :--- | :--- | :--- |
| **File names** | `snake_case` | `mob.gd`, `spawner.gd`, `mob_spawn_config.gd` |
| **Class names (`class_name`)** | `PascalCase` | `Mob`, `Spawner`, `MobSpawnConfig` |
| **Variables & Functions** | `snake_case` | `spawn_interval`, `spawn_mob()` |
| **Constants** | `ALL_CAPS` | `SPAWN_INTERVAL`, `MAX_HEALTH` |
| **Signals** | `snake_case` (past tense/verb) | `spawned`, `rally_set`, `health_changed` |
| **Enum Name** | `PascalCase` | `MobType`, `State` |
| **Enum Keys** | `ALL_CAPS` | `GOBLIN`, `ORC`, `IDLE`, `RUNNING` |

### Why `snake_case` for files?
Godot recommends `snake_case` for all files (scripts, scenes, assets) because different operating systems handle filename casing differently (macOS/Windows are case-insensitive, while Linux is case-sensitive). Using strictly lowercase `snake_case` prevents cross-platform file import bugs.
