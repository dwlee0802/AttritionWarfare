extends Node
class_name Consumer

@export var supplyPriorityLevel: int = 0
@export var ingredientType0: Enums.GoodType = Enums.GoodType.None
@export var ingredientType0_Amount: int = 0
var ingredientType0_Received: float = 0
var ingredientType0_available: bool = false

@export var ingredientType1: Enums.GoodType = Enums.GoodType.None
@export var ingredientType1_Amount: int = 0
var ingredientType1_Received: float = 0
var ingredientType1_available: bool = false

@export var ingredientType2: Enums.GoodType = Enums.GoodType.None
@export var ingredientType2_Amount: int = 0
var ingredientType2_Received: float = 0
var ingredientType2_available: bool = false


func AddIngredient(type, amount):
	if ingredientType0 == type:
		ingredientType0_Received += amount
		return
	if ingredientType1 == type:
		ingredientType1_Received += amount
		return
	if ingredientType2 == type:
		ingredientType2_Received += amount
		return
	
