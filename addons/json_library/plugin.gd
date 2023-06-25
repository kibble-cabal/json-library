@tool
extends EditorPlugin


func _enter_tree() -> void:
	Json.Editor = get_editor_interface()


func _exit_tree() -> void:
	pass
