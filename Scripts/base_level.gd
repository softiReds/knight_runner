extends Node

# Cada nivel puede asignar su propia música desde el editor
@export var level_music: AudioStream

# Volumen opcional por nivel (0 es normal)
@export var music_volume_db: float = 0.0

func _ready():
	# Reproducir la música del nivel (si existe)
	if level_music:
		MusicManager.play_music(level_music)

	# Ajustar volumen del MusicManager según el nivel
	MusicManager.current_track.volume_db = music_volume_db
