extends Area3D
## Simple visible low-poly characters with dialogue.
@export var character_name: String = "Prisoner"
@export_multiline var opening_line: String = "The kitchen has been busy today."
@export var uniform_color := Color(0.32, 0.38, 0.30)
@export var is_staff := false

func _ready() -> void:
    var collision := CollisionShape3D.new()
    var shape := SphereShape3D.new()
    shape.radius = 0.85
    collision.shape = shape
    add_child(collision)
    _build_character()

func _material(color: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.9
    return material

func _add_mesh(mesh: PrimitiveMesh, pos: Vector3, material: Material) -> void:
    var visual := MeshInstance3D.new()
    visual.mesh = mesh
    visual.position = pos
    visual.material_override = material
    add_child(visual)

func _build_character() -> void:
    var clothes := _material(uniform_color if not is_staff else Color(0.25, 0.30, 0.36))
    var skin := _material(Color(0.68, 0.48, 0.34))
    var boots := _material(Color(0.12, 0.13, 0.12))
    var torso := CapsuleMesh.new()
    torso.radius = 0.28
    torso.height = 1.15
    _add_mesh(torso, Vector3(0, 0.85, 0), clothes)
    var head := SphereMesh.new()
    head.radius = 0.19
    head.height = 0.38
    _add_mesh(head, Vector3(0, 1.55, 0), skin)
    var leg := BoxMesh.new()
    leg.size = Vector3(0.18, 0.55, 0.2)
    _add_mesh(leg, Vector3(-0.13, 0.28, 0), boots)
    _add_mesh(leg, Vector3(0.13, 0.28, 0), boots)
    var name_tag := Label3D.new()
    name_tag.text = character_name
    name_tag.position = Vector3(0, 2.0, 0)
    name_tag.font_size = 28
    name_tag.pixel_size = 0.006
    name_tag.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    name_tag.outline_size = 6
    add_child(name_tag)

func interact(_actor: Node) -> String:
    return "%s: %s" % [character_name, opening_line]
