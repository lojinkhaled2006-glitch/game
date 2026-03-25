extends CharacterBody2D
class_name Ball

signal life_lost

@export var ball_speed = 200 
@export var lifes: int = 3
@export var death_zone: DeathZone
@export var ui: UI

var start_position: Vector2

func _ready():
	print(ui)
	ui.set_lifes(lifes)
	start_position = position
	death_zone.life_lost.connect(on_life_lost)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)

	if collision:
		var normal = collision.get_normal()
		var collider = collision.get_collider()

		velocity = velocity.bounce(normal)

		if collider.name == "Paddle":
			velocity.y = -abs(velocity.y)

			var offset = (position.x - collider.position.x) / 100
			velocity.x += offset * 200

		elif collider is Brick:
			print("hit")
			collider.decrease_level()

func start_ball():
	position = start_position
	randomize()
	velocity = Vector2(randf_range(-1, 1), -1).normalized() * ball_speed

func on_life_lost():
	lifes -= 1
	ui.set_lifes(lifes)

	if lifes == 0:
		ui.game_over()
	else:
		life_lost.emit()
		reset_ball()

func reset_ball():
	position = start_position
	velocity = Vector2.ZERO
