extends Node
@export var alien: PackedScene
var score
signal winner

# Inicializo el score.

func _ready() -> void:

	score=0
	$Label.text=str(score)
	
	var id_list = []
	var alien_dict = {}
	var id = 1
	
	# Instancio una fila de aliens por cada uno de los for.
	for column in 6:
		var column_ids = []
		for row in [50,100,150]:
			var current_alien = alien.instantiate()
			alien_dict[id] = current_alien
			column_ids.append(id)
			current_alien.dead.connect(self._score_update)
			current_alien.position=Vector2(45+column*50,row)
			current_alien.id=id
			current_alien.column=column
			if row==150:
				current_alien.can_shoot=true
			else:
				current_alien.can_shoot=false
			current_alien.lost.connect(self._lose)
			add_child(current_alien)
			id+=1
		id_list.append(column_ids)
	alien_dict[1].alien_dict = alien_dict
	alien_dict[1].id_list = id_list


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	## Para testear, si pulsas la tecla F se gana automáticamente
	if Input.is_action_just_pressed("AutoWin"):
		win()
	# pass


#Cambia la variable "score" y luego actualiza el Label. Si llega a cierta cantidad de puntos, llama 
# a la funcion win.  
func _score_update():  
	score+=10
	$Label.text=str(score)
	if score == 180:
		win()

# Muestra en pantalla "HAS GANADO" con el label utilizado para el score
func win():
	var pantalla=get_viewport().size
	$Label.text= "¡HAS GANADO!"

	$Label.position.x=pantalla.x/2-($Label.size.x*1.25)+2
	$Label.position.y=pantalla.y/2-($Label.size.x*1.25)
	
	winner.emit()
	await get_tree().create_timer(3).timeout
	queue_free()
	
func _lose():
	var pantalla=get_viewport().size
	$Label.text= "¡HAS PERDIDO!"

	$Label.position.x=pantalla.x/2-($Label.size.x*1.25)+2
	$Label.position.y=pantalla.y/2-($Label.size.x*1.25)
	
	winner.emit()
	await get_tree().create_timer(3).timeout
	queue_free()
