extends Label

var civCountLabel
var civInvestButton
var milCountLabel
var milInvestButton
var incomeLabel
var nationalTreasuryLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	civCountLabel = $CivCountLabel
	civInvestButton = $CivInvestButton
	milCountLabel = $MilCountLabel
	milInvestButton = $MilInvestButton
	incomeLabel = $IncomeLabel
	nationalTreasuryLabel = $NationalTreasuryLabel
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	civInvestButton.text = "Invest " + str(Game.playerNation.civCount * Game.playerNation.baseInvestmentAmount)
	if Game.playerNation.CivInvestAvailable():
		civInvestButton.disabled = false
	else:
		civInvestButton.disabled = true
		
	milInvestButton.text = "Invest " + str(Game.playerNation.milCount * Game.playerNation.baseInvestmentAmount)
	if Game.playerNation.MilInvestAvailable():
		milInvestButton.disabled = false
	else:
		milInvestButton.disabled = true
	
	nationalTreasuryLabel.text = "National Treasury: " + str(Game.playerNation.nationalTreasury)
