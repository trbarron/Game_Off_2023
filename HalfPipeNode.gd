extends Node3D
# Assuming 'mesh' is your imported mesh resource
var mesh_instance = MeshInstance3D.new()
mesh_instance.mesh = mesh

var static_body = StaticBody3D.new()
mesh_instance.add_child(static_body)

var collision_shape = CollisionShape3D.new()
collision_shape.shape = BoxShape3D.new()
collision_shape.shape.extents = Vector3(1, 1, 1) # Set extents to match your mesh size
static_body.add_child(collision_shape)

# Now add the mesh instance to the scene
add_child(mesh_instance)
