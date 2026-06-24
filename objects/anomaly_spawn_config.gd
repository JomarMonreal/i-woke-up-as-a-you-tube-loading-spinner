extends Resource
class_name AnomalySpawnConfig

enum AnomalyColor {
	Null,
	Red,
	Blue,
	Green
}


@export var count: int = 1
@export var anomaly_keys: Array[AnomalyColor] = []
