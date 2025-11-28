extends Node

var ui_node
var menu_music: AudioStream

func _ready():

	# Obtiene la UI con una ruta relativa en el árbol
	ui_node = get_tree().get_root().get_node("Ui")
	ui_node.hide()

	# Detiene cualquier música que esté reproduciéndose
	MusicManager.stop_music()
	
	# Cargar la música del menú
	menu_music = load("res://Audio/Music/Main_Theme.mp3")
	MusicManager.set_volume(-12.0)
	MusicManager.play_music(menu_music)

	SingleGameManager.reset_stats()

func _exit_tree():
	# Muestra nuevamente la UI al abandonar pantalla de The End
	ui_node.show()
	# No reproducir música aquí — la música la reproduce el nivel automáticamente

func _on_exit_button_pressed() -> void:
	# Cierra completamente la aplicación
	get_tree().quit()

func _on_menu_button_pressed() -> void:
	SingleGameManager.reset_level_progress()
	SingleGameManager.reset_stats(true)
	SingleGameManager.update_points_ui()
	SingleGameManager.update_hearts_ui()
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
