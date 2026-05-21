extends Resource
class_name Resources

@export var gold: int = 0;

func setResources(newResources: Resources):
	#iron = newResources.iron;
	gold = newResources.gold;
	#coal = newResources.coal;
	#wood = newResources.wood;

func addResources(cost: Resources):
	#iron += cost.iron;
	gold += cost.gold;
	#coal += cost.coal;
	#wood += cost.wood;
	
func subtractResources(cost: Resources):
	#iron -= cost.iron;
	gold -= cost.gold;
	#coal -= cost.coal;
	#wood -= cost.wood;
	
func aboveZero():
	#if iron>=0&&gold>=0&&coal>=0&&wood>=0:
	if gold > 0:
		return true;
	else:
		return false;

static func absResources(resources: Resources):
	var newResource: Resources = Resources.new();
	newResource.setResources(resources);
	#newResource.iron = abs(newResource.iron);
	newResource.gold = abs(newResource.gold);
	#newResource.coal = abs(newResource.coal);
	#newResource.wood = abs(newResource.wood);
	return newResource;

static func divideResrouces(resources: Resources, divider: float):
	var newResource: Resources = Resources.new();
	#newResource.setResources(resources);
	#newResource.iron /= divider;
	newResource.gold /= divider;
	#newResource.coal /= divider;
	#newResource.wood /= divider;
	return newResource;
