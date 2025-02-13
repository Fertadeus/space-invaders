# La Escena "estrella" se compone de un Sprite, un CollisionShape (que está deshabilitado dentro
# del objeto, pero es para que no me de Warning) y un VisibleOnScreenNotifier para poder
# liberar al objeto cuando se salga de la pantalla.

extends StaticBody2D
var velocity # Los StaticBody no tienen velocidad por defecto, así que la declaramos


# Al ser un objeto que va a ser instanciado, en su _ready voy a generar su velocidad y escala
# de manera aleatoria. Así habrá variedad y no todas las estrellas sean iguales
func _ready() -> void:
	velocity=20+randf()*50
	scale.x=(randf()*0.5)+0.05
	
	#scale.x=(randf()*0.5)+20 # ->Para comprobar si las estrellas están en la capa adecuada<-
	
	scale.y=scale.x # La escala de las estrellas funciona como un vector. Igualo la 'x' y la 'y' 
					# para que no sean estrellas deformes


# Cambio únicamente la posición dependiendo de la velocidad (que es relativamente aleatoria)
# Básicamente, la fórmula del MRU aplicada aquí (y delta es el tiempo desde el frame anterior)
func _process(delta: float) -> void:
	position.y+=velocity*delta

# Función que libera la estrella de la memoria. Nótese que hay un icono verde a la izquierda.
# Este icono indica que hay una señal conectada a la función en alguno de los objetos del árbol,
# a pesar de que en el código parezca no ser llamada nunca.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	# print("Estrella destruida") # ->Para comprobar que se ha destruido correctamente<-
