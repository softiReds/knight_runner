extends Area2D

@onready var game_manager = $"/root/SingleGameManager"

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		SingleGameManager.decrease_health()
		
