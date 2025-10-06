@abstract
class_name Vector

static func two_to_three(vector2: Vector2, y_component: float = 0.0):
	return Vector3(vector2.x, y_component, vector2.y)

static func flatten(vector3: Vector3) -> Vector2:
	return Vector2(vector3.x, vector3.z)
