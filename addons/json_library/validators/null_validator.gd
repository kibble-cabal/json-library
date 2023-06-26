class_name JNullValidator extends JPropertyValidator


func is_valid(data) -> bool:
	return data == null


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "null": return JNullValidator.new()
	return null
