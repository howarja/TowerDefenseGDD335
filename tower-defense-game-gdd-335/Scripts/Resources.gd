extends Resource
class_name Resources

@export var iron: int = 0;
@export var gold: int = 0;
@export var coal: int = 0;
@export var wood: int = 0;

func _costResources(cost: Resources):
	iron -= cost.iron;
	gold -= cost.gold;
	coal -= cost.coal;
	wood -= cost.wood;
