extends Control

class_name ComparativeTab

var active := false

func _process(delta):
	
	if active:
		if not visible:
			visible = true
		
		global_position = get_global_mouse_position() + Vector2(15,15)
	elif visible:
		visible = false
	
func add_comparation(_comparation_array:Array):
	
	var new_comparation_template = %ComparationNumbersTemplate.duplicate()
	
	new_comparation_template.get_node("Name").text = _comparation_array [0]
	new_comparation_template.get_node("Numbers/02").text = str(_comparation_array [1])
	new_comparation_template.get_node("Numbers/01").text = str(_comparation_array[2])
	
	if _comparation_array[3] != -1:
		new_comparation_template.get_node("Numbers").get_child(_comparation_array[3]).set_deferred("theme_override_colors/font_color",Color.GREEN)
	
	new_comparation_template.visible = true
	%ComparativeContent.add_child(new_comparation_template)


func clear_all_comparations():
	for comparation in %ComparativeContent.get_children():
		comparation.queue_free()

