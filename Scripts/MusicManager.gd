extends Node

# Este nodo administra la música global del juego. Permite cambiar pistas
# según la escena actual sin que el audio se reinicie por error al cambiar de escena.

var current_track: AudioStreamPlayer  # Reproductor de música persistente

func _ready():
	# Se instancia el reproductor de música cuando el autoload inicia
	current_track = AudioStreamPlayer.new()
	add_child(current_track)

func play_music(stream: AudioStream):
	# Si la música solicitada ya está sonando, no se reinicia
	if current_track.stream == stream:
		return
	
	# Se asigna el nuevo audio y se reproduce
	current_track.stream = stream
	current_track.play()

func stop_music():
	# Detiene cualquier pista que esté en reproducción
	current_track.stop()
