@abstract
class_name Vector

static func two_to_three(vector2: Vector2, y_component: float = 0.0):
	return Vector3(vector2.x, y_component, vector2.y)
