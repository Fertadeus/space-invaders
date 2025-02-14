# La Escena "alien" se compone de un AnimatedSprite, un CollisionShape.
# El AnimatedSprite tiene dos animaciones, default y explosión.

extends Area2D
var initial_position # Utilizado para guardar la posición inicial y restringir a partir de ahí
					 # el movimiento del alienígena.
var izq  # Guarda un boolean que será false si se mueve a la derecha y true si se mueve a la izq.   
signal dead

# Guardo la posición inicial, siempre empieza moviéndose a la derecha, y utiliza la animación
# por defecto del alienígena
func _ready() -> void:
	scale=scale*3
	initial_position=self.global_position
	
	izq=false
	$AnimatedSprite2D.play("default")  

# Comprueba si ha llegado al límite de su movimiento, y cambia su dirección si es así.
# También comprueba si ha llegado al tercer frame, y si es así, libera el objeto.
func _process(delta: float) -> void:

	if self.global_position.x > initial_position.x+150:
		izq=true
		
	elif self.global_position.x < initial_position.x:
		izq=false
		
	if izq==false:
		position.x+=70*delta
	else:
		position.x-=70*delta
	if $AnimatedSprite2D.frame==3:
		queue_free()

# Si algún área entra en este objeto, emite su señal "dead" y cambia su animación a explosión.
func _on_area_entered(_area: Area2D) -> void:
	dead.emit()
	$AnimatedSprite2D.play("explosion")


# Ideas sobre este objeto:
#	-Si mueren todos los enemigos de una columna, el resto de aliens debería moverse hasta allí.
#	 Se me ocurren dos ideas (muy generales) para poder hacer que esto suceda. 
#	 1ª idea: guardar los aliens en arrays de columnas. Cuando una columna termina, cambiar la pos
#	 inicial del objeto.
#	 2ª idea: crear CollisionShape adicionales en los aliens, que ocupen un área a su alrededor.
#    Cambiar el movimiento para que los aliens no puedan meterse dentro de un área que no sea suya.
#	
#	 De todas formas, esto no es necesario. Funciona bien así y no merece la pena la molestia.
