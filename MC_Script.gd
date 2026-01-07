extends CharacterBody2D

@export var TILE_SIZE := 16
@export var SPEED := 120.0 #debug speed 

@onready var sprite := $AnimatedSprite2D

enum State {
	IDLE,
	MOVING
}

var state: State = State.IDLE
var target_position: Vector2
var facing := Vector2.DOWN

func _ready():
	global_position = global_position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	target_position = global_position
	enter_idle()

func _physics_process(delta):
	match state:
		State.IDLE:
			idle_state()
		State.MOVING:
			moving_state(delta)

func idle_state():
	var dir := get_input_direction()
	if dir == Vector2.ZERO:
		return

	facing = dir
	target_position = global_position + dir * TILE_SIZE
	enter_moving()

func moving_state(delta):
	var dir := (target_position - global_position).normalized()
	velocity = dir * SPEED

	var collision = move_and_collide(velocity * delta)

	if collision:
		velocity = Vector2.ZERO
		enter_idle()
		return

	if global_position.distance_to(target_position) < 1:
		global_position = target_position
		velocity = Vector2.ZERO
		enter_idle()


func enter_idle():
	state = State.IDLE
	play_idle()

func enter_moving():
	state = State.MOVING
	play_walk()

func get_input_direction() -> Vector2:
	if Input.is_action_pressed("move_left"):
		return Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		return Vector2.RIGHT
	if Input.is_action_pressed("move_up"):
		return Vector2.UP
	if Input.is_action_pressed("move_down"):
		return Vector2.DOWN
	return Vector2.ZERO

func play_walk():
	match facing:
		Vector2.LEFT: sprite.play("walk_left")
		Vector2.RIGHT: sprite.play("walk_right")
		Vector2.UP: sprite.play("walk_up")
		Vector2.DOWN: sprite.play("walk_down")

func play_idle():
	match facing:
		Vector2.LEFT: sprite.play("idle_left")
		Vector2.RIGHT: sprite.play("idle_right")
		Vector2.UP: sprite.play("idle_up")
		Vector2.DOWN: sprite.play("idle_down")
