@tool
extends GridContainer

var item_h_size := 50

func verify_h_size():
	
	var fixed_column_amount = roundi(($"..".size.x / (item_h_size + 4.0)) - 1)
	
	fixed_column_amount = clamp(fixed_column_amount,1,100)
	
	columns = fixed_column_amount


func _on_scroll_container_resized():
	verify_h_size()
