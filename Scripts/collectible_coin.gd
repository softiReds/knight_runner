extends Area2D

var coin_sound
var spawner

func _ready():
	coin_sound = get_node("/root/Ui/CoinSound")

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		SingleGameManager.add_points()
		coin_sound.playing = true # Reproducimos el sonido de la moneda
		queue_free() # eliminarlo
