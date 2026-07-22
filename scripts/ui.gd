extends Control

@onready var box_container_2: BoxContainer = $BoxContainer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(box_container_2.get_children().size()):
		box_container_2.get_child(i).id = i;
		
	for child in box_container_2.get_children():
		child.healthChanged();
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#for i in range(box_container.get_children().size()):
	#	if(PlayerData.health >= i + 1): box_container.get_child(i).active = true;
	#	else: box_container.get_child(i).active = false;
