class_name JsonSchemaLoader extends JsonLoader


func load_validator() -> JPropertyValidator:
	var schema = super.load()
	if schema is Dictionary: return JPropertyValidator.from_schema(schema)
	return null
