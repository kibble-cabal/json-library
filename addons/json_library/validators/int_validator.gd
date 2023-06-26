class_name JIntValidator extends JNumberValidator


func is_valid(data) -> bool:
	if data == null: return is_nullable
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
		if "minimum" in schema: validator.set_minimum(int(schema["minimum"]))
		if "maximum" in schema: validator.set_maximum(int(schema["maximum"]))
		if "multipleOf" in schema: validator.set_step(int(schema["multipleOf"]))
		if "enum" in schema: validator.set_options(schema["enum"])
		return validator
	return null
