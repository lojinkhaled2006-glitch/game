extends StaticBody2D
class_name Brick

signal brick_destroyed

var level = 3

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

var sprites: Array[Texture2D] = [
	preload("res://png/element_blue_square.png"),
	preload("res://png/element_green_square.png"),
	preload("res://png/element_purple_square.png"),
	preload("res://png/element_yellow_square.png"),
	preload("res://png/element_purple_square.png"),
	preload("res://png/element_red_square.png"),
	preload("res://png/element_blue_square_glossy.png")
]

func _ready():
	set_level(level)

func get_size():
	return collision_shape_2d.shape.get_rect().size * sprite_2d.scale

func set_level(new_level: int):
	new_level = clamp(new_level, 1, sprites.size())
	level = new_level
	sprite_2d.texture = sprites[level - 1]

func decrease_level():
	sprite_2d.scale = Vector2(1.2, 1.2)
	await get_tree().create_timer(0.08).timeout
	sprite_2d.scale = Vector2(1, 1)

	if level > 1:
		level -= 1
		sprite_2d.texture = sprites[level - 1]
	else:
		fade_out()

func fade_out():
	collision_shape_2d.disabled = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d, "modulate", Color.TRANSPARENT, 0.3)
	tween.tween_callback(destroy)

func destroy():
	queue_free()
	brick_destroyed.emit()

func get_width():
	return get_size().x
