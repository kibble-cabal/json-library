class_name JNumberValidator extends JPropertyValidator

var has_max: bool = false
var max = 0

var has_min: bool = false
var min = 0

var has_step: bool = false
var step = 0


## Set the maximum value
func set_maximum(value) -> JNumberValidator:
	has_max = true
	max = value
	return self


## Set the minimum value
func set_minimum(value) -> JNumberValidator:
	has_min = true
	min = value
	return self


## Set the step value (e.g. validates that a given number is a multiple of the step [code]value[/code])
func set_step(value) -> JNumberValidator:
	has_step = true
	step = value
	return self


func is_valid(data) -> bool:
	if data == null: return is_nullable
	if not super.is_valid(data): return false
	return (
		(data is float or data is int)
		and (data >= min if has_min else true)
		and (data <= max if has_max else true)
		and (Json.Math.is_rounded(data, step) if has_step else true)
	)


static func from_schema(schema: Dictionary) -> JPropertyValidator:
	if schema.get("type") == "number":
		var validator := JFloatValidator.new()
		if "minimum" in schema: validator.set_minimum(float(schema["minimum"]))
		if "maximum" in schema: validator.set_maximum(float(schema["maximum"]))
		if "multipleOf" in schema: validator.set_step(float(schema["multipleOf"]))
		if "enum" in schema: validator.set_options(schema["enum"])
		return validator
	return null
