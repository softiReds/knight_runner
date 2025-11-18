extends Node

var ui_node

func _ready():

	# Obtiene la UI con una ruta relativa en el árbol
	ui_node = get_tree().get_root().get_node("Ui")
	ui_node.hide()

	# Detiene cualquier música que esté reproduciéndose
	MusicManager.stop_music()

	SingleGameManager.reset_stats()

func _exit_tree():
	# Muestra nuevamente la UI al abandonar el menú
	ui_node.show()
	# No reproducir música aquí — la música la reproduce el nivel automáticamente

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel1.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel2.tscn")
