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
func _process(_delta):
	civInvestButton.text = "Invest " + str(Game.playerNation.civInvestmentAmount)
	if Game.playerNation.CivInvestAvailable():
		civInvestButton.disabled = false
	else:
		civInvestButton.disabled = true
		
	milInvestButton.text = "Invest " + str(Game.playerNation.milInvestmentAmount)
	if Game.playerNation.MilInvestAvailable():
		milInvestButton.disabled = false
	else:
		milInvestButton.disabled = true
	
	nationalTreasuryLabel.text = "National Treasury: " + str(Game.playerNation.nationalTreasury)
	
	incomeLabel.text = "Income: " + str(Game.playerNation.revenuePerCiv * Game.playerNation.civCount) + " / s"
	civCountLabel.text = "Civs: " + str(Game.playerNation.civCount)
	milCountLabel.text = "Mils: " + str(Game.playerNation.milCount)
