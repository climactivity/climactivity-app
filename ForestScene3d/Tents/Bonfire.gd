extends Spatial

var people = []
var ready = false
 
func init_at(params): 
	pass


func _ready():
	$ContactShadow.visible = false
	people = [
		$Spatial,
		$Spatial2,
		$Spatial3,
		$Spatial4,
		$Spatial5,
		$Spatial6,
	]
	ready = true
	GameManager.bonfire = self
	randomize_chars()

func randomize_chars(): 
	if !ready: return
	for person in people:
		person.set_useB(randi() % 2)
