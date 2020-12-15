extends Timer

# using Timer to allow global access of time_left property, yield and create_timer is still used to handle the state machine

# respawning

# tip: if a player teleports to 0,0,0, then SpawnLocations.tscn and its children are missing from the level

var p0_respawn_location = Vector3.ZERO
var p1_respawn_location = Vector3.ZERO
var p2_respawn_location = Vector3.ZERO
var p3_respawn_location = Vector3.ZERO

func get_my_respawn_location(num:int) -> Vector3:
	match num:
		0:
			return p0_respawn_location
		1:
			return p1_respawn_location
	print("Error, could not find player number to teleport")
	return Vector3.ZERO

# statemachine

enum GameStates {
	LOADING,
	WARMUP,
	COUNTDOWN,
	STARTED,
	POSTGAME,
}

var current_gamestate: int = GameStates.LOADING

var warmup_time: float = 3.0
var countdown_time: float = 3.0
var round_time: float = 5.0
var postgame_time: float = 10.0
func _ready():
	set_autostart(false)
	set_one_shot(true)
	switch_gamestate(GameStates.WARMUP)

func switch_gamestate(state:int): # self-contained and recursive
	current_gamestate = state # update our state, so other objects can read what's going on
	match state:
		GameStates.LOADING:
			print("Loading...")
			# Hide Coins
			get_tree().call_group("Coins","change_to_state", Coin.states.DISABLED)
		
		GameStates.WARMUP:
			reset_scores()
			print("Warming up...")
			# Let other objects get our wait_time
			start(warmup_time)
			# Hide Coins
			get_tree().call_group("Coins","change_to_state", Coin.states.DISABLED)
			yield(get_tree().create_timer(warmup_time),"timeout")
			switch_gamestate(GameStates.COUNTDOWN)
		
		GameStates.COUNTDOWN:
			print("Ready...")
			# Reset and Freeze Players
			get_tree().call_group("Players","respawn")
			get_tree().call_group("Players","enable_movement",false)
			# Spawn Coins
			get_tree().call_group("Coins","change_to_state", Coin.states.SPAWNED)
			# Let other objects get our wait_time
			start(countdown_time)
			# Start the countdown timer
			yield(get_tree().create_timer(countdown_time),"timeout")
			switch_gamestate(GameStates.STARTED)
		
		GameStates.STARTED:
			print("Go!")
			# Release Players
			get_tree().call_group("Players","enable_movement",true)
			# Let other objects get our wait_time
			start(round_time)
			# Wait until round is over
			yield(get_tree().create_timer(round_time),"timeout")
			switch_gamestate(GameStates.POSTGAME)
			
		GameStates.POSTGAME:
			print("Finish!")
			# Find out who won
			determine_winner()
			# todo: make sure coins don't respawn when collected and disabled
			get_tree().call_group("Coins","change_to_state", Coin.states.DISABLED)
			yield(get_tree().create_timer(postgame_time),"timeout")
			switch_gamestate(GameStates.WARMUP)
			

# scoring

var p0_score: int = 0
var p1_score: int = 0
var p2_score: int = 0
var p3_score: int = 0

var player_scores = [ # todo, make the above variables condensed and easier to access variably
	0,
	0,
	0,
	0,
]

func determine_winner():
	if p0_score > p1_score:
		print("p0 is the winner!")
	if p1_score > p0_score:
		print("p1 is the winner!")
	if p1_score == p0_score:
		print("it's a tie!")

func add_score(player:int,score:int):
	match player:
		0:
			p0_score += score
			print("p0's score is now %s" % [p0_score])
		1:
			p1_score += score
			print("p1's score is now %s" % [p1_score])

func reset_scores():
	p0_score = 0
	p1_score = 0
	p2_score = 0
	p3_score = 0
	print("All scores reset.")
	get_tree().call_group("Players", "reset_score_label")
