extends HFlowContainer

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	print("can drop")
	if data is IndustryBlock:
		return true
		
	return false
	
	
# swap positions with new block
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# remove old parent's neighbors' bonuses
	var theirParent = data.get_parent()
	
	# swap bonuses for their parent
	if theirParent is IndustrySlot:
		for key in theirParent.neighborSlots.keys():
			theirParent.neighborSlots[key].bonus_speed -= data.industry.bonusAmount
			
	# decoupling
	theirParent.remove_child(data)
	
	# swap children
	add_child(data)
	
	data.position = Vector2.ZERO
