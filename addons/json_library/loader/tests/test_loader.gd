extends JTestRunner

var data_path := Json.Utils.Path.new(Json.get_plugin_directory().path_join("testing/test_data/"))

func _init() -> void:
	tests = (
		test_load_validate()
		+ test_load_object()
		+ test_load_vector()
	)


func test_load_validate() -> Array[JTestCase]:
	return [
		JTestCase.new("load without validating").expect_equal(
			JsonLoader.new(data_path.join("vec2.json"))
				.load,
			{ x = 1.0, y = 2.0 }
		)
	]


func test_load_object() -> Array[JTestCase]:
	return [
		JTestCase.new("load Node").expect_equal(
			func() -> String: return (
				JsonLoader.new(data_path.join("node.json"))
					.output(Node.new())
					.load()
					.name
			),
			"SomeNode"
		)
	]


func test_load_vector() -> Array[JTestCase]:
	return [
		JTestCase.new("load Vector2").expect_equal(
			JsonLoader.new(data_path.join("vec2.json"))
				.validator(JVectorValidator.new().vec2())
				.load,
			Vector2(1, 2)
		),
		JTestCase.new("load dict containing Vector2").expect_equal(
			JsonLoader.new(data_path.join("position.json"))
				.validator(
					JsonValidator.new()
						.add_property("position", JVectorValidator.new().vec2())
				)
				.load,
			{ position = Vector2(1, 1) }
		),
		JTestCase.new("load Vector3 with default").expect_equal(
			JsonLoader.new(data_path.join("vec2.json"))
				.default_dict({ x = -1, y = -1, z = -1 })
				.validator(JVectorValidator.new().vec3().all_optional())
				.load,
			Vector3(1, 2, -1)
		),
	]
