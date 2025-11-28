extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const FRICTION = 100
var jump_label
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var cam = $Camera2D # Referencia a la cámara

@onready var cam_timer: Timer = $CamTimer # Referencia al CamTimer

# Referencia al timer (usado para el coyote time)
@onready var timer = $Timer # Mantiene un margen extra de tiempo

# variables
var accum = 0  # Acumulador que se usa para mover la cámara en el eje X
var itera = 0  # Contador de "iteraciones" (cuántas veces se ha movido hacia la derecha)
var conta = 0  # Contador usado al devolver la cámara hacia la izquierda
var maxim = 50 # Límite de iteraciones antes de empezar el retorno
var steps = 40 # Cantidad de píxeles que se mueve la cámara en cada paso

# Invocar el Timer y desactivar el "drag" en la camara
func CameraMove():
	itera = 0
	conta = 0
	accum = 0
	cam_timer.start()
	cam.drag_horizontal_enabled = false

# Obtener la gravedad de la configuración del proyecto para sincronizar nodos RigidBody.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Añadir guardar y cargar datos de puntos y vidas
	if(Input.is_action_just_pressed("Guardar")):
		SingleGameManager.saveGame()
	
	if(Input.is_action_just_pressed("Cargar")):
		SingleGameManager.loadGame()
		SingleGameManager.update_points_ui()
		SingleGameManager.update_hearts_ui()

	# Añadir animación run y idle 
	if (velocity.x > 1 || velocity.x < -1):
		player_sprite.animation = "Run"
	else:
		player_sprite.animation = "Idle"
	
	# Añadir gravedad.
	if not is_on_floor():
		velocity += get_gravity() * delta
		player_sprite.animation = "Jump"

	# Manejar el salto.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or timer.time_left > 0.0):
		velocity.y = JUMP_VELOCITY
		$JumpSound.play() # Audio feedback 

	# Obtener el input de dirección y manejar el movimiento
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

	# Voltear el personaje
	if velocity.x != 0:
		player_sprite.flip_h = velocity.x < 0 
	
	# Zoom al presionar R (0.5)
	if Input.is_action_just_pressed("ZoomIn"):
		if(cam.zoom <= Vector2(2,2)): # límite - condición para el zoomIn
			cam.zoom = cam.zoom + Vector2(.5,.5)
		
	# Zoom al presionar T (0.5)
	if Input.is_action_just_pressed("ZoomOut"):
		if(cam.zoom > Vector2(.5,.5)): # límite - condición para el zoomOut
			cam.zoom = cam.zoom - Vector2(.5,.5)
		
	# CamerMove presionando J
	if Input.is_action_just_pressed("Recorrido"):
		CameraMove()

	# Almacenar el estado previo del piso
	var was_on_floor = is_on_floor()
	move_and_slide()
	
	# Detectar si el jugador acaba de dejar la plataforma (Inicia coyote time)
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		timer.start()

func _on_cam_timer_timeout():
	# Fase 1: mover hacia la derecha
	if (itera <= maxim):
		accum += steps
		cam.position = Vector2(accum, 0)
		itera += 1
	
	# Fase 2: regresar hacia la izquierda
	if (itera > maxim):
		if (cam.position > Vector2(0,0)):
			accum -= steps
			cam.position = Vector2(accum, 0)
			conta += 1
			
			# Cuando ya regresó al inicio
			if (conta == maxim):
				cam_timer.stop()
				cam.drag_horizontal_enabled = true # Cámara vuelve a seguir al jugador
