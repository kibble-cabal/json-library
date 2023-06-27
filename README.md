# Godot JSON Library

## Why I made this

My goal was to create a library that makes JSON-based mods super easy and safe to implement.

This library makes it easy to load JSON and validate it based on custom validators (or a JSON schema!).
That way, modders can use the familiar JSON format (and all the quality-of-life, autocomplete, etc.
tools already available for JSON) to implement really complex mods without that much knowledge needed.


## Use cases

- Serializing/deserializing user data in a familiar format
- Editable resources in a familiar format
- Adding validation to serialized data
- Using existing JSON Schemas without having to recreate all the validation rules in Godot


## Features
- Load JSON as a `Dictionary` or other Godot `Object` (e.g. Node, Resource, etc.)
- Load JSON Schemas to create validators
- Validate any JSON data type (`object`, `array`, `boolean`, `string`, `null`, `number`, `integer`) or create custom validators
- Validate Godot data types like `Vector2`, `Vector2i`, etc. (see [`JVectorValidator`](addons/json_library/validators/vector_validator.gd))
- Validate file paths (see [`JPathValidator`](addons/json_library/validators/path_validator.gd))

## Tutorials

### Using a JSON Schema

#### 1. Create a JSON Schema file:
`users_schema.json`
```jsonc
{
	"type": "object",
	"properties": {
		"username": {
			"type": string",
		},
		"age": {
			"type": "integer",
			"minimum": 0,
		}
	},
	"required": ["username", "age"]
}
```

#### 2. Create a few JSON data files:
`user_1.json`
```jsonc
{
	"username": "jsmith",
	"age": 24
}
```
`user_2.json`
```jsonc
{
	"username": "bdoe",
	"age": 36
}
```

#### 3. In your main scene, add to `_ready()`:
```gdscript
func _ready() -> void:
	var validator := JsonSchemaLoader.new("users_schema.json").load_validator()
	var user_1 = JsonLoader.new("user_1.json").set_validator(validator).load()
	var user_2 = JsonLoader.new("user_2.json").set_validator(validator).load()
	assert(user_1 == { username = "jsmith", age = 24 })
	assert(user_2 == { username = "bdoe", age = 36 })
	
	# this is invalid, no age:
	assert(validator.is_valid({ username = "some_user" }) == false)
	
	# this is invalid, age is below 0:
	assert(validator.is_valid({ username = "some_user", age = -1 }) == false)
```
