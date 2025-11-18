extends Node

# Este nodo gestiona las estadísticas globales del juego.
# Recibe referencias de la UI para actualizar el HUD sin depender de rutas absolutas.

var points_label: Label               # Referencia al label donde se muestran los puntos
var texture_progress_bar              # Referencia a la barra de progreso de puntos
var puntos: int = 0                   # Contador global de puntos

func register_ui(points_label_ref, progress_ref):
	# Método que registra nodos de la UI para poder actualizarlos
	points_label = points_label_ref
	texture_progress_bar = progress_ref
	reset_stats()

func add_puntos():
	# Incrementa el contador de puntos y actualiza la UI si está registrada
	puntos += 1

	if points_label:
		points_label.text = str(puntos)

	if texture_progress_bar:
		# Se asigna directamente el valor actual para reflejar el progreso
		texture_progress_bar.value = puntos

func reset_stats():
	# Reinicia los valores globales y sincroniza la UI si está presente
	puntos = 0

	if points_label:
		points_label.text = "0"

	if texture_progress_bar:
		texture_progress_bar.value = 0
