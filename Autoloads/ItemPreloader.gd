extends Node

var items_path : String = 'res://Resources/Resources/InventoryResources/AllItems/'
var preload_items : Array[InventoryItem] = []

func _ready():
	preload_items = files_load(items_path, 'tres')
	print(preload_items)
	
func get_item(_item_id: String) -> InventoryItem:
	for i in preload_items:
		if i.item_id == _item_id:
			return i
		else:
			continue
	return null

func files_load(path : String, extension : String):
	if path == null:
		return []
		
	var items : Array[InventoryItem] = []
	var dir = DirAccess.open(path)
	#print("open_path:",path)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var subfolder = path + file_name + '/'
				var res_in_subfolder = files_load(subfolder, extension)
				items.append_array(res_in_subfolder)
			else:
				var file_name_to_load : String
				var res = ResourceLoader.load(path + file_name)
				#if extension == file_name.get_extension():
				#	file_name_to_load = (dir.get_current_dir() + "/" + file_name)
					#items.append(load(file_name_to_load))
				items.append(res)
			file_name = dir.get_next()
		return items
		
	else:
		if !Engine.is_editor_hint():
			print("Can't find items path")
			return []
