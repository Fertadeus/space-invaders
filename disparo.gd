# La Escena "disparo" se compone de un Sprite, un CollisionShape y un VisibleOnScreenNotifier 
# para poder liberar al objeto cuando se salga de la pantalla.

extends Area2D 
var velocidad=Vector2(0,-300) # Quiero que la velocidad sea constante para todos los disparos 


func _ready() -> void:
	set_as_top_level(true)  # Sin esta línea de código, coge ciertas propiedades de el objeto padre.
	scale.x=scale.x+0.8
	scale.y=scale.x
	
  
# Cambio únicamente la posición dependiendo de la velocidad.
# Básicamente, es la fórmula del MRU aplicada aquí (y delta es el tiempo desde el frame anterior)
func _process(delta: float) -> void:
	position+=delta*velocidad

# Las dos funciones siguientes liberan la memoria que ocupa el disparo (eliminándolo efectivamente)
# Una ocurre cuando el disparo sale de la pantalla, otra cuando entra en algún área. Presumiblemente
# habrá dos áreas: la cobertura y los aliens enemigos.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	$CollisionShape2D.set_deferred("disabled",true) #Eliminamos la colisión porque ya se ha destruido
	$Sprite2D.hide()
	# No lo eliminamos hasta que termina el sonido de PIUM
	await get_tree().create_timer(1).timeout
	queue_free()
	
