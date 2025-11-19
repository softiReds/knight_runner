extends Node

# Este nodo gestiona las estadísticas globales del juego.
# Recibe referencias de la UI para actualizar el HUD sin depender de rutas absolutas.

var points_label: Label               # Referencia al label donde se muestran los points
var texture_progress_bar              # Referencia a la barra de progreso de points
var points: int = 0                   # Contador global de points
var lives: int = 3                    # Contador global de vidas

func register_ui(points_label_ref, progress_ref):
	# Método que registra nodos de la UI para poder actualizarlos
	points_label = points_label_ref
	texture_progress_bar = progress_ref
	reset_stats()

func add_points():
	# Incrementa el contador de points y actualiza la UI si está registrada
	points += 1

	if points_label:
		points_label.text = str(points)

	if texture_progress_bar:
		# Se asigna directamente el valor actual para reflejar el progreso
		texture_progress_bar.value = points

func reset_stats():
	# Reinicia los valores globales y sincroniza la UI si está presente
	points = 0

	if points_label:
		points_label.text = "0"

	if texture_progress_bar:
		texture_progress_bar.value = 0

func decrease_health():
	lives -= 1
	print(lives)
	
	if lives == 0:
		lives = 3
		get_tree().call_deferred("reload_current_scene")
		reset_stats()
