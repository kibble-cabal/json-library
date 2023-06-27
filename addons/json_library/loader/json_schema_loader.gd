class_name JsonSchemaLoader extends JsonLoader

## Handles loading and creating validators from JSON schemas

## Loads the JSON (see [method JsonLoader.load]) and (if successful) creates a [JsonValidator] from the loaded [Dictionary]
func load_validator() -> JPropertyValidator:
	var schema = super.load()
	if schema is Dictionary: return JPropertyValidator.from_schema(schema)
	return null
