extends Resource
class_name Resources

@export var iron: int = 0;
@export var gold: int = 0;
@export var coal: int = 0;
@export var wood: int = 0;

func addResources(cost: Resources):
	iron += cost.iron;
	gold += cost.gold;
	coal += cost.coal;
	wood += cost.wood;
	
func aboveZero():
	if iron>0&&gold>0&&coal>0&&wood>0:
		return true;
	else:
		return false;
