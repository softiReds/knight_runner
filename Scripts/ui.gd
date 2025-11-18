extends CanvasLayer

func _ready():
	# Referencia a `PoinstLabel y TestureProgressBar de la UI
	var points_label = $Panel/PointsLabel
	var progress_bar = $TextureRect/TextureProgressBar

	# Registra los nodos de UI en el GameManager
	SingleGameManager.register_ui(points_label, progress_bar)
