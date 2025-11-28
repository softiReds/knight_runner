extends Node

@onready var pause_panel: Panel = %PausePanel

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# Se detecta si el jugador presionó la tecla asignada para pausar
	var pause_pressed = Input.is_action_just_pressed("Pausar")
	
	# Guardamos la ruta d	e la escena cargada actualmente en tiempo real
	var cs = get_tree().get_current_scene()
	var cs_name = ""
	if cs:
		cs_name = cs.name
	
	# Solo se permite pausar si no se está en la escena del menú (por nombre)
	# Esto evita que la pausa se active desde el menú principal
	if (pause_pressed and cs_name != "Menu"):
		get_tree().paused = true
		pause_panel.show()

func _on_resume_button_pressed() -> void:
	# Oculta el panel y reanuda el juego
	pause_panel.hide()
	get_tree().paused = false

func _on_menu_button_pressed() -> void:
	# Cierra pausa, reanuda y regresa al menú principal
	pause_panel.hide()
	get_tree().paused = false
	SingleGameManager.reset_level_progress()
	SingleGameManager.reset_stats()
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	
