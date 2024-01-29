extends Node
class_name Nation

var nationalTreasury: int = 0
var civCount: int = 1
var milCount: int = 0

var revenuePerCiv: int = 100
var civInvestmentAmount = 500
var milInvestmentAmount = 500

@onready var military: Military = Military.new()
@onready var industry: Industry = Industry.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	nationalTreasury += revenuePerCiv * civCount * delta
	industry.Production(delta)


func CivInvest():
	nationalTreasury -= civInvestmentAmount
	civCount += 1
	civInvestmentAmount *= 2


func CivInvestAvailable() -> bool:
	if nationalTreasury >= civInvestmentAmount:
		return true
	else:
		return false
		
		
func MilInvest():
	nationalTreasury -= milInvestmentAmount
	milCount += 1
	milInvestmentAmount *= 2

		
func MilInvestAvailable() -> bool:
	if nationalTreasury >= milInvestmentAmount:
		return true
	else:
		return false


func AssignMil(type, amount):
	if (amount > 0 and FreeMilCount() > 0) or (amount < 0 and industry.factoryAssignment[type] > 0):
		industry.factoryAssignment[type] += amount
	
	
func FreeMilCount():
	var sum = 0
	for i in range(industry.TYPE_COUNT):
		sum += industry.factoryAssignment[i]
	return milCount - sum
