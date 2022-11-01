extends CanvasLayer

onready var SCN_MENU := load("res://scenes/MainMenu.tscn")

onready var btn_menu := $Margin1/VBox1/Menu
onready var credits_container := $Margin1/VBox1/Panel1/Scroll1/Margin1/CreditsContainer
const credits_path := "res://credits.csv"

func _ready() -> void:
	btn_menu.connect("pressed", self, "_on_menu")
	populate()

func populate() -> void:
	Helpers.remove_all_children(credits_container)
	
	var fin := File.new()
	fin.open(credits_path, File.READ)
	
	while !fin.eof_reached():
		var csv := fin.get_csv_line(";")
		if csv.size() == 0 or csv[0].strip_edges() == "":
			continue
		csv[csv.size()-1] = csv[csv.size()-1].strip_edges()
		
		if csv.size() == 1:
			_create_title(csv[0])
		else:
			_create_entry(credits_container, csv[0], csv[1])
		
	fin.close()

func _create_title(title : String) -> void:
	var label := Label.new()
	label.set_text(title)
	label.set_align(Label.ALIGN_CENTER)
	credits_container.add_child(label)
	credits_container.add_child(HSeparator.new())

func _create_entry(container : Container, item : String, creator : String) -> void:
	var item_lbl := Label.new()
	item_lbl.set_stretch_ratio(1.0)
	item_lbl.set_text(item)
	item_lbl.set_autowrap(true)
	item_lbl.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	
	var creator_lbl := Label.new()
	creator_lbl.set_stretch_ratio(2.0)
	creator_lbl.set_text(creator)
	creator_lbl.set_autowrap(true)
	creator_lbl.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	creator_lbl.set_align(Label.ALIGN_RIGHT)
	
	var hbox = HBoxContainer.new()
	hbox.add_child(item_lbl)
	hbox.add_child(creator_lbl)
	container.add_child(hbox)

func _on_menu() -> void:
	var main_node = Helpers.main_node()
	if main_node:
		main_node.change_scene(SCN_MENU)
