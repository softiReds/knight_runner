extends CharacterBody2D

const SPEED = 80
const GRAVITY = 90
const JUMP_POWER = -1000.0
var n_jumps = 1
@onready var game_manager = $"/root/SingleGameManager"

# Tiempo mínimo entre daños al jugador (en segundos)
var damage_cooldown = 1.0
var damage_timer = 0.0

func _ready():
	velocity.x = 0
	$AnimatedSprite2D.play("Idle")

# Dos funciones de colisión que referencian los RayCast2D
func nearPlayer():
	return $Near.is_colliding()  # Ruta explícita a near

func seePlayer():
	return $Right.is_colliding()  # Ruta explícita a Right

# Funciones del movimiento y salto del enemigo
func move():
	velocity.x = SPEED
	$AnimatedSprite2D.play("Run")

func jump():
	if n_jumps > 0:
		velocity.y = JUMP_POWER
		$AnimatedSprite2D.play("Jump")

# Gravedad, movimiento y salto del enemigo
func _physics_process(_delta):
	velocity.y += GRAVITY
	if is_on_floor():
		n_jumps = 1
		if velocity.x > 0:
			$AnimatedSprite2D.play("Run")
		elif velocity.x == 0:
			$AnimatedSprite2D.play("Idle")
	if seePlayer():
		move()
	if nearPlayer():
		jump()
		n_jumps = 0
	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	print("ENTRA AL HURTBOX: ", body, " | name: ", body.name)

	if body.name == "Player":
		print("TAMBIÉN FUNCIONA")
		SingleGameManager.decrease_health()
