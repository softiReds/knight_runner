extends CharacterBody2D

const SPEED = 80
const GRAVITY = 90
@onready var game_manager = $"/root/SingleGameManager"

# Tiempo mínimo entre daños al jugador (en segundos)
var damage_cooldown = 1.0
var player_in_range = null
var damage_timer = 0.0

func _ready():
	velocity.x = SPEED
	# Fuerza a que el sprite mire al mismo lado que velocity.x
	$AnimatedSprite2D.play("Run")

# Dos funciones de colisión que referencian los RayCast2D
func nearRigth():
	var right_node = $Near_Right   # Referencia explícita a Near_Right
	if right_node:
		return right_node.is_colliding()
	return false

func nearLeft():
	var left_node = $Near_Left    # Referencia explícita a Near_Right
	if left_node:
		return left_node.is_colliding()
	return false

# Función para dar giro de 180 grados al enemigo
func flip():
	# Si cualquiera de los RayCast detecta pared, se invierte dirección
	if nearRigth() or nearLeft():
		velocity.x *= -1

# Gravedad y movimiento al enemigo
func _physics_process(delta):
	velocity.y += GRAVITY
	# Se aplica flip antes del movimiento real, igual que el otro enemigo
	flip()

	# Movimiento basado en la velocidad actual
	move_and_slide()

	# Se usa flip_h como sistema único de orientación
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = false

	# Sistema de daño repetido mientras el jugador esté dentro del área (daño repetido)
	if player_in_range:
		damage_timer -= delta # -= Tiempo desde el último frame
		if damage_timer <= 0.0:
			SingleGameManager.decrease_health()
			damage_timer = damage_cooldown  # Reinicia el tiempo entre daños

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = body # Guarda una referencia al jugador indicando que está en el rango de daño
		damage_timer = 0.0     # Permite daño inmediato al entrar sin esperar 1 segundo

func _on_hurtbox_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = null # Indica que el jugador ya no está tocando al enemigo
