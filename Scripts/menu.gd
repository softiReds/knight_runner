extends Node

var ui_node
var menu_music: AudioStream

@onready var tutorial_panel: Panel = %TutorialPanel

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
	# Muestra nuevamente la UI al abandonar el menú
	ui_node.show()
	# No reproducir música aquí — la música la reproduce el nivel automáticamente

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel1.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel2.tscn")

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel3.tscn")

func _on_button_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel4.tscn")

func _on_button_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nivel5.tscn")

# Botón para salir del juego
func _on_exit_button_pressed() -> void:
	# Cierra completamente la aplicación
	get_tree().quit()

# Botón para ver el menú donde se explican los controles del juego
func _on_tutorial_button_pressed() -> void:
	tutorial_panel.show()

# Botón para cerrar el menú de los controles del juego
func _on_close_button_pressed() -> void:
	tutorial_panel.hide()

# Botón para cargar Datos guardados
func _on_load_button_pressed() -> void:
	pass # Replace with function body.
