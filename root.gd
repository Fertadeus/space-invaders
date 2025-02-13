extends Node
@export var estrella: PackedScene
var is_menu_active


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var main = self.get_node("Pantalla1")
	self.remove_child(main)
	main.call_deferred("free")
	
	$EstrellaTimer.start()
	
	for x in 6:	
		var stars= estrella.instantiate()
		stars.position=Vector2(480*randf(),720*randf())
		add_child(stars)
		
	is_menu_active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Start") && is_menu_active):
		#var menu = self.get_node("Menu")
		#self.remove_child(menu)
		#menu.call_deferred("free")
		
		var main_resource = load("res://pantalla1.tscn")
		var main = main_resource.instantiate()
		main.winner.connect(self._on_pantalla_1_winner)
		self.add_child(main)
		
		is_menu_active=false
	

func _on_estrella_timer_timeout() -> void:	
	var star= estrella.instantiate()
	var star_location = $EstrellaSpawn/PathFollow2D
	star_location.progress_ratio = randf()
	star.position=star_location.position
	add_child(star)


func _on_win_timer_timeout() -> void:
	var main = self.get_node("Pantalla1")
	self.remove_child(main)
	main.call_deferred("free")
	
	#var menu_resource = load("res://menu.tscn")
	#var menu = menu_resource.instantiate()
	#self.add_child(menu)
	
	is_menu_active=true


func _on_pantalla_1_winner() -> void:
	$WinTimer.start()
