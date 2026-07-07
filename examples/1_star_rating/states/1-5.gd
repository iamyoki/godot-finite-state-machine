extends State

@onready var stars: HBoxContainer = $"../../Stars"
const STAR = preload("uid://bxf7i2rafguhp")
const STAR_OUTLINE_DEPTH = preload("uid://df0stp2lyr60g")

func enter():
	print('entered')
	for star: TextureRect in stars.get_children():
		if int(star.name) <= int(name):
			star.texture = STAR
		else:
			star.texture = STAR_OUTLINE_DEPTH
