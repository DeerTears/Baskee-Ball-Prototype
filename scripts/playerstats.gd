extends Spatial

# this script handles recieving group calls, input device changes, and updating the hud when appropriate

onready var kinematic = $KinematicBody
onready var model = $KinematicBody/MeshInstance
onready var hud = $HUD

export var player_number: int = 0

var detected_devices = [
	InputEventMouseMotion,
	InputEventJoypadMotion,
]

func _ready():
	# refactor: simplify, either mouse or joypad, this is a 2-player game
	kinematic.player_number = player_number # todo: test with Joypads
	kinematic.look_device = detected_devices[player_number]
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	kinematic.connect("score_changed",self,"change_score")
	kinematic.connect("stamina_changed",self,"update_stamina_label")

func change_score(amount:int): # refactor: unify "change" vs. "set"
	GameInfo.add_score(player_number, amount)
	hud.update_score(GameInfo.p0_score)

func update_stamina_label(amount:float):
	hud.update_stamina(amount)

func reset_score_label():
	hud.update_score(0)

func update_player_number(number:int):
	# refactor: simplify, either mouse or joypad
	player_number = number
	kinematic.player_number = number

func enable_movement(_true:bool):
	kinematic.movement_enabled = _true

func respawn():
	var target = GameInfo.get_my_respawn_location(player_number)
	kinematic.teleport(target, false)
