extends Node

# Este nodo gestiona las estadísticas globales del juego.
# Recibe referencias de la UI para actualizar el HUD sin depender de rutas absolutas.

var points_label: Label               # Referencia al label donde se muestran los puntos
var texture_progress_bar              # Referencia a la barra de progreso de puntos
var hearts_container                  # Referencia al contenedor de corazones en la UI
var points: int = 0                   # Contador global de puntos
var lives: int = 3                    # Contador global de vidas
const MAX_LIVES := 4                  # Valor máximo de vidas posibles

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
	reset_stats()

func add_points():
	# Incrementa el contador de points y actualiza la UI si está registrada
	points += 1

	if points_label:
		points_label.text = str(points)

	if texture_progress_bar:
		# Se asigna directamente el valor actual para reflejar el progreso
		texture_progress_bar.value = points
	
	# Si el jugador encuentra los 10 coleccionables se le suma una vida
	if points >= 10 and lives < MAX_LIVES:
		add_life()

func add_life():
	# Suma una vida si no ha llegado al máximo permitido
	extra_heart_sound.playing = true
	lives += 1
	lives = min(lives, MAX_LIVES)
	update_hearts_ui()

func reset_stats():
	# Reinicia los valores globales y sincroniza la UI si está presente
	points = 0
	lives = 3

	if points_label:
		points_label.text = "0"

	if texture_progress_bar:
		texture_progress_bar.value = 0
	
	# Se actualiza la representación de corazones al reiniciar los valores
	update_hearts_ui()

func decrease_health():
	# Reduce la cantidad de vidas y actualiza visualmente los corazones
	lives -= 1
	hit_sound.playing = true
	update_hearts_ui()

	# Si las vidas llegan a 0, se reinicia el nivel y las estadísticas
	if lives <= 0:
		game_over_sound.playing = true
		lives = 3
		reset_stats()
		get_tree().call_deferred("reload_current_scene")

func update_hearts_ui():
	# Actualiza los corazones visibles según la cantidad de vidas actuales
	if not hearts_container:
		return
	
	# Recorre cada sprite/corazón del contenedor.
	for i in range(hearts_container.get_child_count()):
		var heart = hearts_container.get_child(i)
		
		# Los corazones se muestran si su índice es menor al número de vidas
		heart.visible = i < lives
