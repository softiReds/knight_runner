extends Area2D

# Este nodo representa un obstáculo (pinchos) que mata al jugador al contacto
# Al tocarlo, se resta una vida y se reinicia el nivel actual manteniendo las vidas restantes

@onready var game_manager = get_node("/root/SingleGameManager")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Se resta una vida al jugador usando el GameManager
		game_manager.decrease_health()
		
		# Si aún le quedan vidas, se reinicia la escena actual (solo para pichos)
		# Manteniendo puntos totales y vidas restantes (menos la que acaba de perder)
		if game_manager.lives > 0:
			# Se reinicia el progreso del nivel (puntos) evitando que el jugador tenga vidas extra al morir
			game_manager.reset_level_on_spikes()
			# Se usa call_deferred para evitar errores de colisión en callback
			call_deferred("reload_level_deferred")

# Función diferida para recargar el nivel, evitando errores de física
func reload_level_deferred():
	game_manager.reload_current_level()
