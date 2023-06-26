extends JTestRunner


func _init() -> void:
	tests = (
		test_array_schema()
		+ test_bool_schema()
		+ test_number_schema()
		+ test_object_schema()
		+ test_string_schema()
	)


static func test_array_schema() -> Array[JTestCase]:
	var schema_a := JPropertyValidator.from_schema({
		"type": "array",
		"items": { "type": "string" }
	})
	var schema_b := JPropertyValidator.from_schema({
		"type": "array",
		"items": { "type": "string" },
		"minItems": 1,
		"maxItems": 3,
	})
	var schema_c :=  JPropertyValidator.from_schema({
		"type": "array",
		"items": { "type": "string" },
		"uniqueItems": true
	})
	return [
		JTestCase.new("is array of strings").expect(schema_a.is_valid.bind(["a", "b", "c"])),
		JTestCase.new("is not array of strings").expect_false(schema_a.is_valid.bind([1, 2, 3])),
		JTestCase.new("above minimum items, below maximum items").expect(schema_b.is_valid.bind(["a", "b", "c"])),
		JTestCase.new("below minimum items").expect_false(schema_b.is_valid.bind([])),
		JTestCase.new("above maximum items").expect_false(schema_b.is_valid.bind(["a", "b", "c", "d"])),
		JTestCase.new("has unique items").expect(schema_c.is_valid.bind(["a", "b", "c"])),
		JTestCase.new("has non-unique items").expect_false(schema_c.is_valid.bind(["a", "a", "a"])),
	]


static func test_bool_schema() -> Array[JTestCase]:
	var schema := JPropertyValidator.from_schema({
		"type": "boolean"
	})
	return [
		JTestCase.new("is bool").expect(schema.is_valid.bind(true)),
		JTestCase.new("is not bool").expect_false(schema.is_valid.bind("ok")),
	]


static func test_number_schema() -> Array[JTestCase]:
	var schema_float := JPropertyValidator.from_schema({
		"type": "number",
		"minimum": 1,
		"maximum": 10,
	})
	var schema_int := JPropertyValidator.from_schema({
		"type": "integer",
		"minimum": 1,
		"maximum": 10,
	})
	var schema_int_exclusive := JPropertyValidator.from_schema({
		"type": "integer",
		"exclusiveMinimum": 1,
		"exclusiveMaximum": 10,
	})
	return [
		JTestCase.new("is float").expect(schema_float.is_valid.bind(1.0)),
		JTestCase.new("is not float").expect_false(schema_float.is_valid.bind("hello world")),
		JTestCase.new("is integer").expect(schema_int.is_valid.bind(1)),
		JTestCase.new("is not integer").expect_false(schema_int.is_valid.bind("hello world")),
		JTestCase.new("is below minimum").expect_false(schema_int.is_valid.bind(-1)),
		JTestCase.new("is above maximum").expect_false(schema_int.is_valid.bind(100)),
		JTestCase.new("is below minimum (exclusive)").expect_false(schema_int_exclusive.is_valid.bind(1)),
		JTestCase.new("is above maximum (exclusive)").expect_false(schema_int_exclusive.is_valid.bind(10)),
	]


static func test_object_schema() -> Array[JTestCase]:
	var schema_a := JPropertyValidator.from_schema({
		"type": "object",
		"properties": {
			"my_key": { "type": "string" }
		},
	})
	var schema_b := JPropertyValidator.from_schema({
		"type": "object",
		"properties": {
			"my_key": { "type": "string" }
		},
		"required": ["my_key"]
	})
	return [
		JTestCase.new("is object").expect(schema_a.is_valid.bind({})),
		JTestCase.new("is not object").expect_false(schema_a.is_valid.bind(true)),
		JTestCase.new("has required keys").expect(schema_b.is_valid.bind({ my_key = "hello world" })),
		JTestCase.new("missing required keys").expect_false(schema_b.is_valid.bind({ some_key = "hello world" })),
	]


static func test_string_schema() -> Array[JTestCase]:
	var schema_a := JPropertyValidator.from_schema({
		"type": "string"
	})
	var schema_b := JPropertyValidator.from_schema({
		"type": "string",
		"minLength": 5
	})
	var schema_c := JPropertyValidator.from_schema({
		"type": "string",
		"minLength": 5,
		"maxLength": 10
	})
	return [
		JTestCase.new("is string").expect(schema_a.is_valid.bind("hello world")),
		JTestCase.new("is not string").expect_false(schema_a.is_valid.bind(0)),
		JTestCase.new("above minimum length").expect(schema_b.is_valid.bind("hello world")),
		JTestCase.new("below minimum length").expect_false(schema_b.is_valid.bind("")),
		JTestCase.new("below maximum length").expect(schema_c.is_valid.bind("hello")),
		JTestCase.new("above maximum length").expect_false(schema_c.is_valid.bind("hello world")),
	]
