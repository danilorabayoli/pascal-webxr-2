extends Node3D
## Procedural first-pass reconstruction of a 17th-century French scholar's study.

var mat_plaster: StandardMaterial3D
var mat_oak: StandardMaterial3D
var mat_dark_oak: StandardMaterial3D
var mat_stone: StandardMaterial3D
var mat_floor: StandardMaterial3D
var mat_gold: StandardMaterial3D
var mat_book_red: StandardMaterial3D
var mat_book_green: StandardMaterial3D
var mat_book_blue: StandardMaterial3D
var mat_paper: StandardMaterial3D
var mat_iron: StandardMaterial3D
var xr_interface: XRInterface
var xr_origin: XROrigin3D
var camera: XRCamera3D
var status_label: Label
var xr_button: Button
var move_speed := 2.0
var is_vr := false

func _ready() -> void:
	_make_materials()
	_make_lighting()
	_make_ground_floor()
	_make_upper_gallery()
	_make_staircase()
	_make_furniture()
	_make_bookshelves()
	_make_windows_and_wall_details()
	_make_player()
	_make_hud()

func _material(color: Color, roughness := 0.82, metallic := 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.metallic = metallic
	return m

func _box(label: String, size: Vector3, pos: Vector3, material: Material, parent: Node3D = null) -> MeshInstance3D:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = label
	var box := BoxMesh.new()
	box.size = size
	mesh_node.mesh = box
	mesh_node.material_override = material
	mesh_node.position = pos
	(parent if parent != null else self).add_child(mesh_node)
	return mesh_node

func _cylinder(label: String, radius: float, height: float, pos: Vector3, material: Material, sides := 12) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = label
	var cylinder := CylinderMesh.new()
	cylinder.top_radius = radius
	cylinder.bottom_radius = radius
	cylinder.height = height
	cylinder.radial_segments = sides
	node.mesh = cylinder
	node.material_override = material
	node.position = pos
	add_child(node)
	return node

func _make_materials() -> void:
	mat_plaster = _material(Color("b9a58a"))
	mat_oak = _material(Color("4b2d19"))
	mat_dark_oak = _material(Color("28180f"))
	mat_stone = _material(Color("62564a"))
	mat_floor = _material(Color("60432d"))
	mat_gold = _material(Color("a77b36"), 0.42, 0.35)
	mat_book_red = _material(Color("6f2520"))
	mat_book_green = _material(Color("314b38"))
	mat_book_blue = _material(Color("263b50"))
	mat_paper = _material(Color("d8c49a"))
	mat_iron = _material(Color("242321"), 0.5, 0.65)

func _make_lighting() -> void:
	var world_env := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = Color("252b36")
	sky_mat.sky_horizon_color = Color("88765d")
	sky_mat.ground_bottom_color = Color("201a15")
	sky_mat.ground_horizon_color = Color("62503d")
	sky.sky_material = sky_mat
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("b9a184")
	env.ambient_light_energy = 0.48
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	world_env.environment = env
	add_child(world_env)
	var sun := DirectionalLight3D.new()
	sun.name = "Late afternoon light"
	sun.rotation_degrees = Vector3(-42, -28, 0)
	sun.light_color = Color("ffd7a0")
	sun.light_energy = 0.62
	sun.shadow_enabled = true
	add_child(sun)
	var warm := OmniLight3D.new()
	warm.name = "Candlelit ambience"
	warm.position = Vector3(0, 2.8, 0)
	warm.light_color = Color("ffb45f")
	warm.light_energy = 1.2
	warm.omni_range = 8.0
	warm.shadow_enabled = true
	add_child(warm)

func _make_ground_floor() -> void:
	_box("Oak plank floor", Vector3(12, 0.22, 10), Vector3(0, -0.11, 0), mat_floor)
	for i in range(1, 17):
		var x := -5.55 + float(i) * 0.69
		_box("Floor plank seam %02d" % i, Vector3(0.018, 0.008, 9.7), Vector3(x, 0.006, 0), mat_dark_oak)
	_box("Back wall left", Vector3(4.0, 4.0, 0.25), Vector3(-4.0, 2.0, -4.9), mat_plaster)
	_box("Back wall right", Vector3(4.0, 4.0, 0.25), Vector3(4.0, 2.0, -4.9), mat_plaster)
	_box("Back wall centre", Vector3(4.0, 1.2, 0.25), Vector3(0, 3.4, -4.9), mat_plaster)
	_box("Left wall", Vector3(0.25, 4.0, 10.0), Vector3(-5.9, 2.0, 0), mat_plaster)
	_box("Right wall", Vector3(0.25, 4.0, 10.0), Vector3(5.9, 2.0, 0), mat_plaster)
	_box("Front wall left", Vector3(3.2, 4.0, 0.25), Vector3(-4.4, 2.0, 4.9), mat_plaster)
	_box("Front wall right", Vector3(3.2, 4.0, 0.25), Vector3(4.4, 2.0, 4.9), mat_plaster)
	_box("Front lintel", Vector3(5.6, 0.55, 0.25), Vector3(0, 3.72, 4.9), mat_plaster)
	for x in [-5.2, -2.6, 0.0, 2.6, 5.2]:
		_box("Ceiling beam", Vector3(0.18, 0.22, 9.7), Vector3(x, 3.94, 0), mat_dark_oak)
	for x in [-5.72, 5.72]:
		_box("Corner timber post", Vector3(0.22, 4.0, 0.22), Vector3(x, 2.0, -4.72), mat_dark_oak)
	for z in [-4.72, 4.72]:
		_box("Baseboard", Vector3(11.4, 0.18, 0.12), Vector3(0, 0.13, z), mat_dark_oak)

func _make_upper_gallery() -> void:
	_box("Upper gallery west", Vector3(4.2, 0.2, 5.2), Vector3(-3.7, 3.45, -1.7), mat_floor)
	_box("Upper gallery east", Vector3(4.2, 0.2, 5.2), Vector3(3.7, 3.45, -1.7), mat_floor)
	_box("Gallery front beam", Vector3(11.0, 0.22, 0.22), Vector3(0, 3.53, 1.0), mat_dark_oak)
	for x in [-1.5, -0.75, 0.0, 0.75, 1.5]:
		_box("Gallery baluster", Vector3(0.10, 0.9, 0.10), Vector3(x, 4.0, 0.98), mat_oak)
	_box("Gallery handrail", Vector3(3.5, 0.14, 0.16), Vector3(0, 4.48, 0.98), mat_dark_oak)
	_box("Upper back half wall", Vector3(11.5, 0.7, 0.2), Vector3(0, 3.9, -4.65), mat_plaster)
	_box("Upper study table top", Vector3(1.8, 0.12, 0.9), Vector3(3.6, 4.05, -2.2), mat_oak)
	for x in [2.9, 4.3]:
		for z in [-2.5, -1.9]:
			_box("Upper table leg", Vector3(0.10, 0.75, 0.10), Vector3(x, 3.65, z), mat_dark_oak)
	_add_book_stack(Vector3(3.5, 4.15, -2.2), 4)

func _make_staircase() -> void:
	for i in range(12):
		var t := float(i) / 11.0
		var z := 3.4 - t * 5.1
		var y := 0.13 + t * 3.25
		_box("Oak stair %02d" % i, Vector3(1.55, 0.18, 0.48), Vector3(-1.65, y, z), mat_oak)
	var rail_left := _box("Stair stringer left", Vector3(0.14, 3.8, 0.22), Vector3(-2.42, 1.8, 0.85), mat_dark_oak)
	rail_left.rotation.x = deg_to_rad(-33)
	var rail_right := _box("Stair stringer right", Vector3(0.14, 3.8, 0.22), Vector3(-0.88, 1.8, 0.85), mat_dark_oak)
	rail_right.rotation.x = deg_to_rad(-33)

func _make_furniture() -> void:
	_box("Writing desk top", Vector3(2.4, 0.16, 1.1), Vector3(0.5, 1.05, -0.5), mat_oak)
	for x in [-0.48, 1.48]:
		for z in [-0.9, -0.1]:
			_box("Desk leg", Vector3(0.13, 1.0, 0.13), Vector3(x, 0.52, z), mat_dark_oak)
	_box("Desk apron", Vector3(2.15, 0.25, 0.12), Vector3(0.5, 0.83, 0.0), mat_dark_oak)
	var parchment := _box("Open parchment", Vector3(0.78, 0.025, 0.52), Vector3(0.42, 1.15, -0.45), _material(Color("d8c49a")))
	parchment.rotation.y = deg_to_rad(-9)
	_box("Ledger book", Vector3(0.45, 0.11, 0.32), Vector3(1.18, 1.19, -0.55), mat_book_red)
	_box("Inkwell base", Vector3(0.12, 0.09, 0.12), Vector3(-0.25, 1.19, -0.35), mat_iron)
	_cylinder("Quill shaft", 0.012, 0.42, Vector3(-0.12, 1.23, -0.45), mat_paper, 6).rotation.z = deg_to_rad(-55)
	_cylinder("Brass candle stem", 0.035, 0.22, Vector3(1.25, 1.24, -0.15), mat_gold)
	_cylinder("Candle wax", 0.045, 0.24, Vector3(1.25, 1.43, -0.15), _material(Color("e8d9b6")))
	var candle_light := OmniLight3D.new()
	candle_light.position = Vector3(1.25, 1.58, -0.15)
	candle_light.light_color = Color("ff9b42")
	candle_light.light_energy = 0.7
	candle_light.omni_range = 3.2
	add_child(candle_light)
	_box("Chair seat", Vector3(0.72, 0.16, 0.68), Vector3(0.5, 0.58, 0.75), mat_oak)
	for x in [0.22, 0.78]:
		for z in [0.48, 1.02]:
			_box("Chair leg", Vector3(0.09, 0.56, 0.09), Vector3(x, 0.28, z), mat_dark_oak)
	_box("Chair back", Vector3(0.72, 0.95, 0.12), Vector3(0.5, 1.05, 1.04), mat_oak)
	_box("Fireplace stone surround", Vector3(2.2, 1.9, 0.48), Vector3(0, 0.98, -4.55), mat_stone)
	_box("Fireplace opening", Vector3(1.18, 1.18, 0.12), Vector3(0, 0.78, -4.27), mat_dark_oak)
	_box("Mantel", Vector3(2.5, 0.16, 0.58), Vector3(0, 1.95, -4.43), mat_dark_oak)
	_box("Fire ember", Vector3(0.58, 0.24, 0.06), Vector3(0, 0.43, -4.19), _material(Color("c34f1d"), 0.4))
	var fire_glow := OmniLight3D.new()
	fire_glow.position = Vector3(0, 0.8, -3.9)
	fire_glow.light_color = Color("ff6c28")
	fire_glow.light_energy = 1.0
	fire_glow.omni_range = 3.5
	add_child(fire_glow)
	_box("Woven study rug", Vector3(4.0, 0.025, 3.0), Vector3(0.2, 0.018, 0.2), _material(Color("6d3024")))
	_box("Rug inner border", Vector3(3.65, 0.012, 2.65), Vector3(0.2, 0.038, 0.2), _material(Color("b28a4d")))

func _make_bookshelves() -> void:
	for side in [-1, 1]:
		var x := float(side) * 5.55
		_box("Tall bookcase back", Vector3(0.22, 3.1, 3.1), Vector3(x, 1.7, -1.3), mat_dark_oak)
		for level in range(5):
			var y := 0.35 + float(level) * 0.68
			_box("Bookcase shelf", Vector3(0.62, 0.10, 3.2), Vector3(x - float(side) * 0.25, y, -1.3), mat_oak)
			for b in range(10):
				var z := -2.72 + float(b) * 0.31
				var h := 0.38 + float((b + level) % 3) * 0.08
				var book_mat: Material = [mat_book_red, mat_book_green, mat_book_blue, mat_dark_oak][(b + level) % 4]
				_box("Old leather book", Vector3(0.30, h, 0.20), Vector3(x - float(side) * 0.27, y + 0.08 + h * 0.5, z), book_mat)
				_box("Book spine gilt", Vector3(0.012, h * 0.7, 0.018), Vector3(x - float(side) * 0.43, y + 0.08 + h * 0.5, z), mat_gold)
	_add_book_stack(Vector3(-1.8, 0.22, -3.7), 3)

func _add_book_stack(origin: Vector3, count: int) -> void:
	var book_mats: Array[Material] = [mat_book_red, mat_book_green, mat_book_blue]
	for i in range(count):
		var book := _box("Stacked folio", Vector3(0.52 - float(i % 2) * 0.04, 0.12, 0.36), origin + Vector3(0, 0.06 + float(i) * 0.13, 0), book_mats[i % book_mats.size()])
		book.rotation.y = deg_to_rad(float(i % 2) * 5.0)

func _make_windows_and_wall_details() -> void:
	for side in [-1, 1]:
		var x := float(side) * 5.72
		var z := -3.0
		_box("Window frame top", Vector3(0.16, 0.14, 1.65), Vector3(x, 2.8, z), mat_dark_oak)
		_box("Window frame bottom", Vector3(0.16, 0.14, 1.65), Vector3(x, 1.45, z), mat_dark_oak)
		_box("Window frame front", Vector3(0.16, 1.4, 0.14), Vector3(x, 2.12, z - 0.78), mat_dark_oak)
		_box("Window frame back", Vector3(0.16, 1.4, 0.14), Vector3(x, 2.12, z + 0.78), mat_dark_oak)
		_box("Window vertical mullion", Vector3(0.12, 1.3, 0.08), Vector3(x, 2.12, z), mat_oak)
		_box("Window horizontal mullion", Vector3(0.12, 0.08, 1.45), Vector3(x, 2.12, z), mat_oak)
	_box("Woven tapestry", Vector3(0.08, 1.75, 1.45), Vector3(-5.7, 2.3, 1.0), _material(Color("7a3027")))
	_box("Tapestry central field", Vector3(0.04, 1.35, 1.05), Vector3(-5.64, 2.3, 1.0), _material(Color("9e7440")))
	for y in [1.55, 3.05]:
		_box("Tapestry rail", Vector3(0.14, 0.10, 1.6), Vector3(-5.62, y, 1.0), mat_dark_oak)

func _make_player() -> void:
	xr_origin = XROrigin3D.new()
	xr_origin.name = "XROrigin"
	xr_origin.position = Vector3(0, 0, 3.5)
	add_child(xr_origin)
	camera = XRCamera3D.new()
	camera.name = "XRCamera"
	camera.position = Vector3(0, 1.65, 0)
	xr_origin.add_child(camera)
	var left_hand := XRController3D.new()
	left_hand.name = "LeftHand"
	left_hand.tracker = "left_hand"
	xr_origin.add_child(left_hand)
	var right_hand := XRController3D.new()
	right_hand.name = "RightHand"
	right_hand.tracker = "right_hand"
	xr_origin.add_child(right_hand)

func _make_hud() -> void:
	var layer := CanvasLayer.new()
	layer.name = "StartVROverlay"
	add_child(layer)
	var panel := PanelContainer.new()
	panel.position = Vector2(20, 20)
	panel.custom_minimum_size = Vector2(330, 0)
	layer.add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)
	var title := Label.new()
	title.text = "LE CABINET DE BLAISE PASCAL"
	title.add_theme_font_size_override("font_size", 18)
	content.add_child(title)
	var intro := Label.new()
	intro.text = "Étude française, XVIIe siècle\nExplorez le cabinet et la galerie supérieure."
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(intro)
	xr_button = Button.new()
	xr_button.text = "Entrer en réalité virtuelle"
	xr_button.custom_minimum_size = Vector2(290, 52)
	xr_button.pressed.connect(_enter_vr)
	content.add_child(xr_button)
	var reset_button := Button.new()
	reset_button.text = "Recentrer la position"
	reset_button.pressed.connect(_recenter)
	content.add_child(reset_button)
	status_label = Label.new()
	status_label.text = "Mode écran — utilisez WASD pour vous déplacer."
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(status_label)

func _enter_vr() -> void:
	if xr_interface != null and xr_interface.is_initialized():
		get_viewport().use_xr = true
		is_vr = true
		status_label.text = "VR active."
		return
	var webxr := XRServer.find_interface("WebXR")
	if webxr != null and OS.has_feature("web"):
		webxr.session_mode = "immersive-vr"
		webxr.required_features = ["local-floor"]
		webxr.optional_features = ["hand-tracking"]
		webxr.session_started.connect(_on_xr_started, CONNECT_ONE_SHOT)
		webxr.session_failed.connect(_on_xr_failed, CONNECT_ONE_SHOT)
		status_label.text = "Demande d'ouverture de la session WebXR…"
		var ok: bool = webxr.initialize()
		if not ok:
			status_label.text = "WebXR n'a pas pu démarrer. Vérifiez le navigateur et réessayez."
			return
		xr_interface = webxr
		return
	var openxr := XRServer.find_interface("OpenXR")
	if openxr != null:
		status_label.text = "Initialisation d'OpenXR…"
		if openxr.initialize():
			xr_interface = openxr
			get_viewport().use_xr = true
			is_vr = true
			status_label.text = "OpenXR actif — VR prête."
			return
	status_label.text = "VR indisponível neste build. Use o botão num build WebXR ou OpenXR."

func _on_xr_started() -> void:
	get_viewport().use_xr = true
	is_vr = true
	if status_label != null:
		status_label.text = "WebXR ativo — aproveite o estudo."

func _on_xr_failed() -> void:
	if status_label != null:
		status_label.text = "O navegador recusou a sessão VR. Tente novamente ou use o build OpenXR."

func _recenter() -> void:
	if xr_origin != null:
		xr_origin.position = Vector3(0, 0, 3.5)
	if xr_interface != null and xr_interface.is_initialized():
		xr_interface.request_reference_space("local-floor")
	if status_label != null:
		status_label.text = "Posição reiniciada."

func _process(delta: float) -> void:
	if is_vr:
		return
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()
	if direction.length() > 0.01:
		var forward := -camera.global_basis.z
		forward.y = 0
		forward = forward.normalized()
		var right := camera.global_basis.x
		right.y = 0
		right = right.normalized()
		xr_origin.position += (right * direction.x + forward * direction.y) * move_speed * delta
		xr_origin.position.x = clampf(xr_origin.position.x, -5.0, 5.0)
		xr_origin.position.z = clampf(xr_origin.position.z, -4.0, 4.0)
