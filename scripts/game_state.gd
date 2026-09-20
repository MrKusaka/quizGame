extends Node

# ---------- РЕЖИМ ИГРЫ ----------
enum GameMode { LIVES, TIMER }

# ---------- ФЛАГИ СОСТОЯНИЯ ----------
var game_mode: GameMode = GameMode.LIVES
var game_started: bool = false
var waiting_for_next: bool = false

# ---------- ОЧКИ И ЖИЗНИ ----------
var score: int = 0
var lives: int = 3
var max_lives: int = 3

# ---------- ТАЙМЕР ----------
var time_left: float = 30.0
var time_bonus: float = 0.5

# ---------- ТЕКУЩИЙ ВОПРОС ----------
var current_item: Dictionary = {}
var selected_components: Array = []

# ---------- СБРОС ----------
func reset():
	score = 0
	lives = max_lives
	time_left = 30.0
	waiting_for_next = false
	current_item = {}
	selected_components.clear()
