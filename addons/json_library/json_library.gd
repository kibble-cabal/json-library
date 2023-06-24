class_name Json extends Object

## See ["addons/json_library/utils/math.gd"] and ["addons/json_library/utils/path.gd"]
const Utils := {
	Math = preload("utils/math.gd"),
	Path = preload("utils/path.gd")
}

# Validators

## See [JArrayValidator]
const ArrayValidator := preload("validators/array_validator.gd")

## See [JBoolValidator]
const BoolValidator := preload("validators/bool_validator.gd")

## See [JEnumValidator]
const EnumValidator := preload("validators/enum_validator.gd")

## See [JFloatValidator]
const FloatValidator := preload("validators/float_validator.gd")

## See [JIntValidator]
const IntValidator := preload("validators/int_validator.gd")

## See [JsonValidator]
const JsonValidator := preload("validators/json_validator.gd")

## See [JNumberValidator]
const NumberValidator := preload("validators/number_validator.gd")

## See [JPathValidator]
const PathValidator := preload("validators/path_validator.gd")

## See [JPropertyValidator]
const PropertyValidator := preload("validators/json_property_validator.gd")

## See [JStringValidator]
const StringValidator := preload("validators/string_validator.gd")

## See [JVectorValidator]
const VectorValidator := preload("validators/vector_validator.gd")
