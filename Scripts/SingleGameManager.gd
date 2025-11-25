extends Node

# Este nodo gestiona las estadísticas globales del juego.
# Recibe referencias de la UI para actualizar el HUD sin depender de rutas absolutas.

var points_label: Label               # Referencia al label donde se muestran los puntos totales
var texture_progress_bar              # Referencia a la barra de progreso de puntos por nivel
var hearts_container                  # Referencia al contenedor de corazones en la UI

var points_total: int = 0             # Contador global de puntos (no se reinicia entre niveles)
var points_level: int = 0             # Contador de puntos del nivel actual (se reinicia cada nivel)
var lives: int = 3                    # Contador global de vidas
const MAX_LIVES := 7                  # Valor máximo de vidas posibles

var extra_heart_sound
var hit_sound
var game_over_sound

func _ready():
	# Accedemos a los nodos con los audioStreamPlayers de UI
	extra_heart_sound = get_node("/root/Ui/ExtraHeartSound")
	game_over_sound = get_node("/root/Ui/GameOverSound")
	hit_sound = get_node("/root/Ui/HitSound")

func register_ui(points_label_ref, progress_ref, hearts_ref):
	# Método que registra nodos de la UI para poder actualizarlos
	points_label = points_label_ref
	texture_progress_bar = progress_ref
	hearts_container = hearts_ref
	update_hearts_ui()
	update_points_ui()
	reset_level_progress()  # Al registrar UI, se reinicia progreso del nivel

# --- Puntos y vidas ---
func add_points():
	# Incrementa los contadores de puntos y actualiza la UI
	points_total += 1
	points_level += 1
	update_points_ui()
	
	# Si el jugador encuentra los 10 coleccionables en este nivel, suma una vida
	if points_level >= 10 and lives < MAX_LIVES:
		add_life()

func add_life():
	# Suma una vida si no ha llegado al máximo permitido
	extra_heart_sound.playing = true
	lives += 1
	lives = min(lives, MAX_LIVES)
	update_hearts_ui()

# --- Reinicios ---
func reset_stats(full_reset: bool = false):
	# Reinicia los valores globales y sincroniza la UI si está presente
	# full_reset = true -> reinicia puntos totales y vidas (nuevo juego / menú)
	if full_reset:
		points_total = 0
		lives = 3

	update_hearts_ui()
	update_points_ui()
	reset_level_progress()  # Siempre reinicia el progreso del nivel para la UI

func reset_level_progress():
	# Reinicia solo los puntos de nivel (para la barra de progreso) sin afectar puntos totales
	points_level = 0
	if texture_progress_bar:
		texture_progress_bar.value = 0

func decrease_health():
	# Reduce la cantidad de vidas y actualiza visualmente los corazones
	lives -= 1
	hit_sound.playing = true
	update_hearts_ui()

	# Si las vidas llegan a 0, se reinicia el nivel y las estadísticas
	if lives <= 0:
		game_over_sound.playing = true
		reset_stats(true)  # Reinicio completo: puntos totales y vidas
		get_tree().call_deferred("reload_current_scene")

# --- Actualización UI ---
func update_hearts_ui():
	# Actualiza los corazones visibles según la cantidad de vidas actuales
	if not hearts_container:
		return
	
	# Recorre cada sprite/corazón del contenedor
	for i in range(hearts_container.get_child_count()):
		var heart = hearts_container.get_child(i)
		
		# Los corazones se muestran si su índice es menor al número de vidas
		heart.visible = i < lives

func update_points_ui():
	# Actualiza la UI de puntos y barra de progreso
	if points_label:
		points_label.text = str(points_total)  # Se muestra el total acumulado
	if texture_progress_bar:
		texture_progress_bar.value = points_level  # Barra refleja solo progreso del nivel
