# La Escena "disparo" se compone de un Sprite, un CollisionShape y un VisibleOnScreenNotifier 
# para poder liberar al objeto cuando se salga de la pantalla.

extends Area2D 
signal game_over
var velocidad=Vector2(0,150) # Velocidad constante de bajada 


func _ready() -> void:
	set_as_top_level(true)  # Sin esta línea de código, coge ciertas propiedades de el objeto padre.
	scale.x=scale.x*2
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

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Nave" or area.name=="Nave":
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	game_over.emit() # Si la bala toca la nave, que es un body, emite hit
	queue_free()
