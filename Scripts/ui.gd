extends CanvasLayer

func _ready():
	# Referencia a `PointsLabel` y `TextureProgressBar` de la UI
	var points_label = $Panel/PointsLabel
	var progress_bar = $TextureRect/TextureProgressBar
	
	# Referencia al contenedor de corazones
	var hearts_container = $Lives/HeartsContainer
	
	# Registra los nodos de UI en el GameManager
	SingleGameManager.register_ui(points_label, progress_bar, hearts_container)
