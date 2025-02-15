extends Node
@export var alien: PackedScene
var score
signal winner

# Inicializo el score.

func _ready() -> void:

	score=0
	$Label.text=str(score)
	
	# Instancio una fila de aliens por cada uno de los for.
	for x in 6:
		var aliens= alien.instantiate()
		aliens.dead.connect(self._score_update)
		aliens.position=Vector2(45+x*50,50)
		add_child(aliens)
		
	for x in 6:
		var aliens= alien.instantiate()
		aliens.dead.connect(self._score_update)
		aliens.position=Vector2(45+x*50,100)
		
		add_child(aliens)
		
	for x in 6:
		var aliens= alien.instantiate()
		aliens.dead.connect(self._score_update)
		aliens.position=Vector2(45+x*50,150)
		add_child(aliens)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


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
