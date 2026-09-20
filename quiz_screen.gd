extends Control

# ---------- ССЫЛКИ НА НОДЫ ----------
@onready var score_label: Label = $ScoreLabel
@onready var lives_label: Label = $LivesLabel
@onready var item_name_label: Label = $ItemNameLabel
@onready var item_image: TextureRect = $ItemImage
@onready var components_container: GridContainer = $ComponentsContainer
@onready var message_label: Label = $MessageLabel
@onready var slots_container: HBoxContainer = $SlotsContainer
@onready var timer_label: Label = $TimerLabel


func _ready():
	# ---------- ФОН ----------
	var bg = get_node_or_null("Background")
	if bg == null:
		bg = get_node_or_null("../Background")
	if bg:
		bg.anchor_left = 0
		bg.anchor_top = 0
		bg.anchor_right = 1
		bg.anchor_bottom = 1
		bg.offset_left = 0
		bg.offset_top = 0
		bg.offset_right = 0
		bg.offset_bottom = 0
		bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		move_child(bg, 0)
	
	# ---------- КОРНЕВАЯ НОДА ----------
	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1
	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0
	
	# ---------- SCORELABEL ----------
	score_label.anchor_left = 0
	score_label.anchor_top = 0
	score_label.anchor_right = 1
	score_label.anchor_bottom = 0
	score_label.offset_left = 0
	score_label.offset_top = 80
	score_label.offset_right = 0
	score_label.offset_bottom = 130
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	score_label.add_theme_font_size_override("font_size", 32)
	score_label.text = "Очки: 0"
	
	# ---------- LIVESLABEL ----------
	lives_label.anchor_left = 1
	lives_label.anchor_top = 0
	lives_label.anchor_right = 1
	lives_label.anchor_bottom = 0
	lives_label.offset_left = -200
	lives_label.offset_top = 80
	lives_label.offset_right = -20
	lives_label.offset_bottom = 130
	lives_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	lives_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lives_label.add_theme_font_size_override("font_size", 32)
	
	# ---------- TIMERLABEL ----------
	timer_label.anchor_left = 1
	timer_label.anchor_top = 0
	timer_label.anchor_right = 1
	timer_label.anchor_bottom = 0
	timer_label.offset_left = -200
	timer_label.offset_top = 130
	timer_label.offset_right = -20
	timer_label.offset_bottom = 170
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	timer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	timer_label.add_theme_font_size_override("font_size", 32)
	timer_label.text = ""
	
	# ---------- ITEMNAMELABEL ----------
	item_name_label.anchor_left = 0.5
	item_name_label.anchor_top = 0
	item_name_label.anchor_right = 0.5
	item_name_label.anchor_bottom = 0
	item_name_label.offset_left = -250
	item_name_label.offset_top = 250
	item_name_label.offset_right = 250
	item_name_label.offset_bottom = 300
	item_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	item_name_label.add_theme_font_size_override("font_size", 36)
	item_name_label.text = ""
	
	# ---------- ITEMIMAGE ----------
	item_image.anchor_left = 0.5
	item_image.anchor_top = 0
	item_image.anchor_right = 0.5
	item_image.anchor_bottom = 0
	item_image.offset_left = -100
	item_image.offset_top = 320
	item_image.offset_right = 100
	item_image.offset_bottom = 520
	item_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# ---------- SLOTSCONTAINER ----------
	slots_container.anchor_left = 0.5
	slots_container.anchor_top = 0
	slots_container.anchor_right = 0.5
	slots_container.anchor_bottom = 0
	slots_container.offset_left = -300
	slots_container.offset_top = 540
	slots_container.offset_right = 300
	slots_container.offset_bottom = 640
	slots_container.alignment = BoxContainer.ALIGNMENT_CENTER
	slots_container.add_theme_constant_override("separation", 15)
	
	# ---------- COMPONENTSCONTAINER ----------
	components_container.columns = 4
	components_container.anchor_left = 0.5
	components_container.anchor_top = 1
	components_container.anchor_right = 0.5
	components_container.anchor_bottom = 1
	components_container.offset_left = -245
	components_container.offset_top = -400
	components_container.offset_right = 245
	components_container.offset_bottom = -120
	components_container.add_theme_constant_override("separation", 15)
	
	# ---------- MESSAGELABEL ----------
	message_label.anchor_left = 0
	message_label.anchor_top = 1
	message_label.anchor_right = 1
	message_label.anchor_bottom = 1
	message_label.offset_left = 0
	message_label.offset_top = -40
	message_label.offset_right = 0
	message_label.offset_bottom = -5
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size", 28)
	
	# ---------- КНОПКА "ДОМОЙ" ----------
	var menu_btn = Button.new()
	menu_btn.name = "MenuButton"
	menu_btn.text = "🏠"
	menu_btn.anchor_left = 0
	menu_btn.anchor_top = 0
	menu_btn.anchor_right = 0
	menu_btn.anchor_bottom = 0
	menu_btn.offset_left = 20
	menu_btn.offset_top = 80
	menu_btn.offset_right = 120
	menu_btn.offset_bottom = 180
	menu_btn.add_theme_font_size_override("font_size", 48)
	menu_btn.pressed.connect(_on_menu_button_pressed)
	add_child(menu_btn)
	
	# ---------- ЗАПУСК ----------
	DataLoader.load_items()
	show_start_menu()


# ---------- ЖИЗНЕННЫЙ ЦИКЛ ----------

func _process(delta):
	if not GameState.game_started:
		return
	if GameState.game_mode == GameState.GameMode.TIMER and not GameState.waiting_for_next:
		GameState.time_left -= delta
		if GameState.time_left <= 0:
			GameState.time_left = 0
			update_timer_label()
			game_over_timer()
			return
		update_timer_label()


# ---------- СТАРТОВОЕ МЕНЮ ----------

func show_start_menu():
	GameState.game_started = false
	GameState.time_left = 30.0
	timer_label.text = ""
	lives_label.text = ""
	score_label.text = "Очки: 0"
	message_label.text = ""
	item_image.texture = null
	item_name_label.text = ""
	clear_slots()
	for child in components_container.get_children():
		child.queue_free()
	
	if get_node_or_null("StartOverlay"):
		return
	
	var overlay = ColorRect.new()
	overlay.name = "StartOverlay"
	overlay.color = Color(0, 0, 0, 0.85)
	overlay.anchor_left = 0
	overlay.anchor_top = 0
	overlay.anchor_right = 1
	overlay.anchor_bottom = 1
	add_child(overlay)
	
	var vbox = VBoxContainer.new()
	vbox.name = "StartButtons"
	vbox.anchor_left = 0.5
	vbox.anchor_top = 0.5
	vbox.anchor_right = 0.5
	vbox.anchor_bottom = 0.5
	vbox.offset_left = -260
	vbox.offset_top = -150
	vbox.offset_right = 260
	vbox.offset_bottom = 150
	vbox.add_theme_constant_override("separation", 40)
	overlay.add_child(vbox)
	
	var btn_lives = Button.new()
	btn_lives.text = "❤️ 3 жизни"
	btn_lives.custom_minimum_size = Vector2(500, 120)
	btn_lives.add_theme_font_size_override("font_size", 36)
	btn_lives.pressed.connect(_on_mode_selected.bind(GameState.GameMode.LIVES))
	vbox.add_child(btn_lives)
	
	var btn_timer = Button.new()
	btn_timer.text = "⏱ На время (30 сек)"
	btn_timer.custom_minimum_size = Vector2(500, 120)
	btn_timer.add_theme_font_size_override("font_size", 36)
	btn_timer.pressed.connect(_on_mode_selected.bind(GameState.GameMode.TIMER))
	vbox.add_child(btn_timer)


func _on_mode_selected(mode):
	GameState.game_mode = mode
	GameState.game_started = true
	var overlay = get_node_or_null("StartOverlay")
	if overlay:
		overlay.queue_free()
	start_new_game()


func _on_menu_button_pressed():
	show_start_menu()


# ---------- ИГРОВОЙ ПРОЦЕСС ----------
func start_new_game():
	GameState.reset()
	update_score()
	update_timer_label()
	next_question()


func next_question():
	GameState.waiting_for_next = false
	GameState.selected_components.clear()
	message_label.text = ""
	message_label.modulate = Color.WHITE
	
	if DataLoader.all_items.is_empty():
		return
	
	GameState.current_item = DataLoader.all_items[randi() % DataLoader.all_items.size()]
	item_name_label.text = "Собери: " + GameState.current_item["name"]
	create_slots(GameState.current_item["components"].size())
	
	var item_icon_path = DataLoader.to_icon_path(GameState.current_item["name"])
	if ResourceLoader.exists(item_icon_path):
		item_image.texture = load(item_icon_path)
	else:
		item_image.texture = null
		push_warning("Нет картинки для: " + GameState.current_item["name"])
	
	for child in components_container.get_children():
		child.queue_free()
	
	var correct: Array = GameState.current_item["components"].duplicate()
	var options: Array = []
	
	for c in correct:
		options.append(c)
	
	var all_component_names: Array = []
	for item in DataLoader.all_items:
		for comp in item["components"]:
			if not all_component_names.has(comp):
				all_component_names.append(comp)
	
	if all_component_names.has(GameState.current_item["name"]):
		all_component_names.erase(GameState.current_item["name"])
	
	var decoys_pool: Array = []
	for comp in all_component_names:
		if not correct.has(comp):
			decoys_pool.append(comp)
	decoys_pool.shuffle()
	
	# Добиваем до 8 кнопок обманками
	for decoy in decoys_pool:
		if options.size() >= 8:
			break
		options.append(decoy)
	
	options.shuffle()
	
	for comp_name in options:
		var btn = Button.new()
		btn.set_meta("component_name", comp_name)
		btn.custom_minimum_size = Vector2(110, 110)
		btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		btn.flat = true
		btn.add_theme_constant_override("icon_max_width", 90)
		var comp_icon_path = DataLoader.to_icon_path(comp_name)
		if ResourceLoader.exists(comp_icon_path):
			btn.icon = load(comp_icon_path)
		btn.pressed.connect(_on_component_pressed.bind(comp_name, btn))
		components_container.add_child(btn)
	
	print("Собери: ", GameState.current_item["name"], " | правильные: ", correct)


func _on_component_pressed(comp_name: String, btn: Button):
	if GameState.waiting_for_next:
		return
	
	message_label.text = ""
	message_label.modulate = Color.WHITE
	
	var already_selected := 0
	for c in GameState.selected_components:
		if c == comp_name:
			already_selected += 1
	
	var needed := 0
	for c in GameState.current_item["components"]:
		if c == comp_name:
			needed += 1
	
	if needed > 0 and already_selected >= needed:
		return
	
	GameState.selected_components.append(comp_name)
	btn.disabled = true
	btn.modulate = Color(1, 1, 1, 0.3)
	
	fill_next_slot(comp_name)
	
	var correct: Array = GameState.current_item["components"]
	if GameState.selected_components.size() >= correct.size():
		check_answer()


func _on_slot_clicked(slot_btn: Button):
	if GameState.waiting_for_next:
		return
	if slot_btn.icon == null:
		return
	
	var comp_name = slot_btn.get_meta("component_name", "")
	if comp_name == "":
		return
	
	var idx = GameState.selected_components.find(comp_name)
	if idx != -1:
		GameState.selected_components.remove_at(idx)
	
	slot_btn.icon = null
	slot_btn.modulate = Color(0.4, 0.4, 0.4, 1.0)
	slot_btn.remove_meta("component_name")
	
	for child in components_container.get_children():
		if child is Button and child.get_meta("component_name", "") == comp_name and child.disabled:
			child.disabled = false
			child.modulate = Color.WHITE
			return


# ---------- СЛОТЫ ----------

func create_slots(count: int):
	for child in slots_container.get_children():
		child.queue_free()
	
	for i in range(count):
		var slot_btn = Button.new()
		slot_btn.custom_minimum_size = Vector2(100, 100)
		slot_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#slot_btn.flat = true
		slot_btn.add_theme_constant_override("icon_max_width", 80)
		slot_btn.pressed.connect(_on_slot_clicked.bind(slot_btn))
		slots_container.add_child(slot_btn)


func clear_slots():
	for slot_btn in slots_container.get_children():
		if slot_btn is Button:
			slot_btn.icon = null
			slot_btn.modulate = Color(0.4, 0.4, 0.4, 1.0)
			if slot_btn.has_meta("component_name"):
				slot_btn.remove_meta("component_name")


func fill_next_slot(comp_name: String):
	for slot_btn in slots_container.get_children():
		if slot_btn is Button and slot_btn.icon == null:
			var icon_path = DataLoader.to_icon_path(comp_name)
			if ResourceLoader.exists(icon_path):
				slot_btn.icon = load(icon_path)
				slot_btn.modulate = Color.WHITE
			slot_btn.set_meta("component_name", comp_name)
			return


# ---------- ПРОВЕРКА ОТВЕТА ----------

func check_answer():
	GameState.waiting_for_next = true
	var correct: Array = GameState.current_item["components"].duplicate()
	var selected: Array = GameState.selected_components.duplicate()
	correct.sort()
	selected.sort()
	
	if selected == correct:
		GameState.score += 1
		update_score()
		if GameState.game_mode == GameState.GameMode.TIMER:
			GameState.time_left += GameState.time_bonus
			update_timer_label()
		message_label.text = "✅ Верно!"
		message_label.modulate = Color.GREEN
		await get_tree().create_timer(0.2).timeout
		next_question()
	else:
		if GameState.game_mode == GameState.GameMode.LIVES:
			GameState.lives -= 1
			update_score()
			if GameState.lives <= 0:
				GameState.game_started = false
				message_label.text = "💀 Игра окончена! Очков: " + str(GameState.score)
				message_label.modulate = Color.RED
				await get_tree().create_timer(2.5).timeout
				show_start_menu()
				return
		
		clear_slots()
		GameState.selected_components.clear()
		GameState.waiting_for_next = false
		message_label.text = ""
		message_label.modulate = Color.WHITE
		for child in components_container.get_children():
			if child is Button:
				child.disabled = false
				child.modulate = Color.WHITE


# ---------- ОБНОВЛЕНИЕ UI ----------

func update_score():
	score_label.text = "Очки: " + str(GameState.score)
	if GameState.game_mode == GameState.GameMode.LIVES:
		lives_label.text = "❤️".repeat(GameState.lives)
	else:
		lives_label.text = ""


func update_timer_label():
	if GameState.game_mode == GameState.GameMode.TIMER:
		timer_label.text = "⏱ " + str(snapped(GameState.time_left, 0.1)) + " сек"
		if GameState.time_left < 5:
			timer_label.modulate = Color.RED
		else:
			timer_label.modulate = Color.WHITE
	else:
		timer_label.text = ""


func game_over_timer():
	GameState.game_started = false
	GameState.waiting_for_next = true
	message_label.text = "⏱ Время вышло! Очков: " + str(GameState.score)
	message_label.modulate = Color.RED
	await get_tree().create_timer(3.0).timeout
	message_label.text = ""
	message_label.modulate = Color.WHITE
	show_start_menu()
