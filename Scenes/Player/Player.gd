extends KinematicBody
class_name Player

var movement_vector:Vector3
var speed:int = 70
var mouse_sensitivity:float = 0.2
	
onready var neck:MeshInstance = $CollisionShape/Neck
onready var head:MeshInstance = $CollisionShape/Neck/Head
onready var body:MeshInstance = $CollisionShape/Body
onready var head_raycast:RayCast = $CollisionShape/Neck/Head/HeadRayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		var left_right = deg2rad(event.relative.x * mouse_sensitivity)
		var up_down = deg2rad(event.relative.y * mouse_sensitivity)
		
		head.rotate_x(up_down)
		#neck.rotate_z(left_right)
		
		#if neck.rotation.z <= deg2rad(-75) or neck.rotation.z >= deg2rad(75):
		self.rotate_y(-left_right)
		
		head.rotation.x = clamp(head.rotation.x, deg2rad(-75), deg2rad(75))
		neck.rotation.z = clamp(neck.rotation.z, deg2rad(-75), deg2rad(75))
			
func _process(delta):
	var forward_back = Input.get_action_strength("move_forwards") - Input.get_action_strength("move_backwards")
	var left_right = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if forward_back != 0 or left_right != 0:
		var diff = self.rotation.y - neck.rotation.z
						
	var direction = (self.transform.basis.z * forward_back - self.transform.basis.x * left_right).normalized()
	
	var new_movement_vector = lerp(movement_vector, direction * 10, 0.25)

	new_movement_vector.y = -9.8

	movement_vector = self.move_and_slide(new_movement_vector, Vector3.UP)
	
	
