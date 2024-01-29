extends Node
class_name Nation

var nationalTreasury: int = 0
var civCount: int = 1
var milCount: int = 0

var revenuePerCiv: int = 100
var baseInvestmentAmount = 1000

@onready var military: Military = Military.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	nationalTreasury += revenuePerCiv * civCount * delta


func CivInvest():
	nationalTreasury -= baseInvestmentAmount * civCount
	civCount += 1


func CivInvestAvailable() -> bool:
	if nationalTreasury >= baseInvestmentAmount * civCount:
		return true
	else:
		return false
		
		
func MilInvest():
	nationalTreasury -= baseInvestmentAmount * milCount
	milCount += 1

		
func MilInvestAvailable() -> bool:
	if nationalTreasury >= baseInvestmentAmount * milCount:
		return true
	else:
		return false
	
	
