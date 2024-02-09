extends Label

var milUsageLabel

var factoryCountLabel
var producedLabel
var stockLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	milUsageLabel = $MilUsageLabel
	factoryCountLabel = $DataColumns/FactoryCountLabel
	producedLabel = $DataColumns/ProducedLabel
	stockLabel = $DataColumns/StockLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	factoryCountLabel.text = ""
	producedLabel.text = ""
	stockLabel.text = ""
	
	milUsageLabel.text = "Mills " + str(-(Game.playerNation.FreeMilCount() - Game.playerNation.milCount))+ "/" + str(Game.playerNation.milCount) + " Used"
	for i in range(Game.playerNation.industry.TYPE_COUNT):
		factoryCountLabel.text += str(Game.playerNation.industry.factoryAssignment[i]) + "\n"
		producedLabel.text += str(Game.playerNation.industry.factoryAssignment[i] * Game.playerNation.industry.productionPerFactory[i]) + "\n"
		stockLabel.text += str(int(Game.playerNation.industry.stock[i])) + "\n"
