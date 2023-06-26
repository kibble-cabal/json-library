class_name JIntValidator extends JNumberValidator


func is_valid(data) -> bool:
	if data == null: return _is_nullable
	return super.is_valid(data) and Json.Math.is_rounded(data)


func cleaned_data(data, default = 0) -> int:
	return (
		roundi(data) if data is float
		else data if data is int
		else default
	)


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "integer":
		var validator := JIntValidator.new()
		if "minimum" in schema: validator.minimum(int(schema["minimum"]))
		if "maximum" in schema: validator.maximum(int(schema["maximum"]))
		if "multipleOf" in schema: validator.step(int(schema["multipleOf"]))
		if "enum" in schema: validator.options(schema["enum"])
		return validator
	return null
