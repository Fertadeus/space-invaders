# La Escena "alien" se compone de un AnimatedSprite, un CollisionShape.
# El AnimatedSprite tiene dos animaciones, default y explosión.

extends Area2D
@export var disparo_alien: PackedScene


static var alien_dict # Variable comun para todos los aliens y relaciona cada id con su escena Alien
static var id_list # Variable comun para todos los aliens con los ids de los aliens vivos 
var can_shoot
var id
var column
var initial_position # Utilizado para guardar la posición inicial y restringir a partir de ahí
# el movimiento del alienígena.
var izq  # Guarda un boolean que será false si se mueve a la derecha y true si se mueve a la izq.   
signal dead
signal lost


# Guardo la posición inicial, siempre empieza moviéndose a la derecha, y utiliza la animación
# por defecto del alienígena
func _ready() -> void:
	scale=scale*3
	initial_position=self.global_position
	izq=false
	$Cooldown.wait_time=5*randf()+1
	$Cooldown.start()
	
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
		
# Cuando termina el timer permite volver a disparar
func _on_cooldown_timeout() -> void:
	$Cooldown.stop()
	$Cooldown.wait_time=4+4*randf()
	$Cooldown.start()
	if can_shoot:
		var pium = disparo_alien.instantiate()
		pium.position=position+Vector2(0,20)
		pium.game_over.connect(self.game_over)
		add_child(pium)
		

# Si algún área entra en este objeto, emite su señal "dead" y cambia su animación a explosión.
func _on_area_entered(area: Area2D) -> void:
	# Solo si lo que entra en el area es un disparo de la nave
	if area.get_parent().name == 'Nave':
		dead.emit()
		can_shoot = false # Ya está muerto, así que no puede disparar
		$CollisionShape2D.set_deferred("disabled",true) #Eliminamos la colisión porque ya está muerto
		$AnimatedSprite2D.play("explosion")
		# Eliminamos el alien de la lista de ids porque ha muerto
		id_list[column].erase(id)
		if len(id_list[column]) > 0:
			# Cogemos la id del alien que está al frente de la columna donde ha muerto nuestro alien
			var id_max = id_list[column].max()
			# El nuevo alien ya puede disparar
			alien_dict[id_max].can_shoot=true
		# No lo eliminamos hasta que las balas salen de la pantalla
			await get_tree().create_timer(5).timeout
			queue_free()

func game_over():
	lost.emit()
	
# Ideas para mejora:
#	-Si mueren todos los enemigos de una columna, el resto de aliens debería moverse hasta allí.
#	 Se me ocurren dos ideas (muy generales) para poder hacer que esto suceda. 
#	 1ª idea: Cuando una columna termina, cambiar la posinicial del objeto.
#	 2ª idea: crear CollisionShape adicionales en los aliens, que ocupen un área a su alrededor.
#    Cambiar el movimiento para que los aliens no puedan meterse dentro de un área que no sea suya.
#
