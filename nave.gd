# La Escena "Nave" se compone de un AnimatedSprite, un CollisionPolygon y un Timer, que evita que
# el jugador dispare constantemente, y tenga que esperar entre disparo y disparo. Además, exporta
# la escena disparo, aunque no esté incluida en el árbol.

extends CharacterBody2D
@export var disparo: PackedScene
var isInCooldown # Variable que guardará un Boolean, que indicará si el jugador puede disparar o no
var screen_size

# Set posicion y permiso de disparo
func _ready() -> void:
	screen_size = get_viewport_rect().size #Recoge el tamaño de la pantalla en una variable
	position.x = screen_size.x/2  # Posición inicial
	position.y = (screen_size.y/6)*5
	isInCooldown=false  # Empieza pudiendo disparar

# MRU para la nave, comprueba ciertos Inputs para realizar las acciones.
func _physics_process(delta: float) -> void:
	velocity.x=0
	
	position+=velocity*delta
	
	if Input.is_action_pressed("Derecha"):
		velocity.x=100
	elif Input.is_action_pressed("Izquierda"):
		velocity.x=-100
	
	# El disparo instancia un objeto disparo. Comprueba que el cooldown (1s) ha terminado antes de 
	# permitir un disparo
	
	if Input.is_action_just_pressed("Disparo") && isInCooldown==false:
		var pium= disparo.instantiate()
		pium.position=position+Vector2(0,-4)
		isInCooldown=true
		$Cooldown.start()
		add_child(pium)
	
	# Move and slide es la función que tiene el CharacterBody. Simula físicas por su parte y 
	# una vez simuladas devuelve el movimiento que tiene que realizar. Nótese que para este juego
	# concreto, el tipo de movimiento está declarado en el Inspector de variables como 'Floating'.
	move_and_slide()
	
	#Evito que salga de la pantalla
	position = position.clamp(Vector2(8,0), screen_size-Vector2(8,0))
	
	# Cambio su animación dependiendo de la velocidad que lleve. También podría haberlo hecho arriba,
	# esto es por si en algún momento quiero añadirle algún tipo de aceleración a la nave.
	if velocity.x>0:		
		$AnimatedSprite2D.animation="giroderecha"
	elif velocity.x<0:	
		$AnimatedSprite2D.animation="giroizquierda"
	elif velocity.x==0:
		$AnimatedSprite2D.animation="default"

# Cuando termina el timer permite volver a disparar
func _on_cooldown_timeout() -> void:
	isInCooldown=false
	

## ESTO NO FUNCIONA PORQUE NO ES UN AREA2D.
# https://forum.godotengine.org/t/collisionpolygon2d-doesnt-have-a-collision-signal/619

# https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html#using-characterbody2d-3d

# UNA ALTERNATIVA ES QUE CUANDO LA BALA TOCA LA NAVE DESDE LA PROPIA BALA SE MANDE LA SEÑAL??

#func _on_area_entered(area: Area2D) -> void:
	#print('hola')
	#print(area.name)
	#if area.name == "Disparo_alien":
		#$CollisionShape2D.set_deferred("disabled",true) #Eliminamos la colisión porque ya se ha destruido
		#$AnimatedSprite2D.play("explosion") # FALTA CREAR LA ANIMACIÓN
		#$AnimatedSprite2D.hide()
		#game_over.emit()
		#queue_free()
