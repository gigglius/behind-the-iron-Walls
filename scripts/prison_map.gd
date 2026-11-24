extends Node3D
## Greyboxed, walkable prison complex. Coordinates align with the existing gameplay stations.

var concrete: StandardMaterial3D
var dark_concrete: StandardMaterial3D
var floor_mat: StandardMaterial3D
var metal: StandardMaterial3D
var wood: StandardMaterial3D
var sign_mat: StandardMaterial3D

func _ready() -> void:
    concrete = _mat(Color(0.48, 0.49, 0.45))
    dark_concrete = _mat(Color(0.27, 0.29, 0.28))
    floor_mat = _mat(Color(0.34, 0.35, 0.32))
    metal = _mat(Color(0.16, 0.19, 0.18))
    wood = _mat(Color(0.34, 0.23, 0.14))
    sign_mat = _mat(Color(0.72, 0.68, 0.53))
    _build_courtyard()
    _build_cell_block()
    _build_room_details()
    _build_cafeteria()
    _build_kitchen()
    _build_workshop()
    _build_laundry()
    _build_admin()
    _build_yard()
    _build_connectors()
    _build_courtyard_props()

func _mat(color: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.92
    return material

func _box(parent: Node3D, label: String, pos: Vector3, size: Vector3, material: Material, solid := true) -> MeshInstance3D:
    var body := StaticBody3D.new() if solid else Node3D.new()
    body.name = label
    body.position = pos
    parent.add_child(body)
    var mesh_node := MeshInstance3D.new()
    var mesh := BoxMesh.new()
    mesh.size = size
    mesh_node.mesh = mesh
    mesh_node.material_override = material
    body.add_child(mesh_node)
    if solid:
        var collision := CollisionShape3D.new()
        var shape := BoxShape3D.new()
        shape.size = size
        collision.shape = shape
        body.add_child(collision)
    return mesh_node

func _label(parent: Node3D, words: String, pos: Vector3, size := 0.65) -> void:
    var label := Label3D.new()
    label.text = words
    label.position = pos
    label.font_size = 48
    label.pixel_size = 0.004
    label.modulate = Color(0.92, 0.86, 0.68)
    label.outline_size = 8
    label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    label.scale = Vector3.ONE * size
    parent.add_child(label)

func _room(name: String, center: Vector3, dimensions: Vector2, door_side: String) -> void:
    var room := Node3D.new()
    room.name = name
    room.position = center
    add_child(room)
    var w := dimensions.x
    var d := dimensions.y
    _box(room, "Floor", Vector3(0, -0.12, 0), Vector3(w, 0.24, d), floor_mat)
    var h := 3.8
    var t := 0.3
    _wall_with_door(room, "North", Vector3(0, h * 0.5, -d * 0.5), w, h, t, door_side.split("_").has("north"), true)
    _wall_with_door(room, "South", Vector3(0, h * 0.5, d * 0.5), w, h, t, door_side.split("_").has("south"), true)
    _wall_with_door(room, "West", Vector3(-w * 0.5, h * 0.5, 0), d, h, t, door_side.split("_").has("west"), false)
    _wall_with_door(room, "East", Vector3(w * 0.5, h * 0.5, 0), d, h, t, door_side.split("_").has("east"), false)
    _label(room, name.to_upper(), Vector3(0, 2.5, 0), 0.7)

func _wall_with_door(parent: Node3D, side: String, center: Vector3, length: float, height: float, thickness: float, has_door: bool, horizontal: bool) -> void:
    var wall_size := Vector3(length, height, thickness) if horizontal else Vector3(thickness, height, length)
    if not has_door:
        _box(parent, side + "Wall", center, wall_size, concrete)
        return
    var gap := 2.0
    var segment := (length - gap) * 0.5
    var offset := (gap + segment) * 0.5
    var a := center
    var b := center
    if horizontal:
        a.x -= offset
        b.x += offset
        _box(parent, side + "WallA", a, Vector3(segment, height, thickness), concrete)
        _box(parent, side + "WallB", b, Vector3(segment, height, thickness), concrete)
        _box(parent, side + "Lintel", Vector3(center.x, height - 0.25, center.z), Vector3(gap, 0.5, thickness), concrete)
    else:
        a.z -= offset
        b.z += offset
        _box(parent, side + "WallA", a, Vector3(thickness, height, segment), concrete)
        _box(parent, side + "WallB", b, Vector3(thickness, height, segment), concrete)
        _box(parent, side + "Lintel", Vector3(center.x, height - 0.25, center.z), Vector3(thickness, 0.5, gap), concrete)
    _box(parent, side + "DoorFrameLeft", center + (Vector3(-gap * 0.5, 1.5, 0) if horizontal else Vector3(0, 1.5, -gap * 0.5)), Vector3(0.12, 3.0, 0.12), metal)
    _box(parent, side + "DoorFrameRight", center + (Vector3(gap * 0.5, 1.5, 0) if horizontal else Vector3(0, 1.5, gap * 0.5)), Vector3(0.12, 3.0, 0.12), metal)

func _build_courtyard() -> void:
    var area := Node3D.new()
    area.name = "CentralCourtyard"
    area.position = Vector3(0, 0, -5)
    add_child(area)
    _box(area, "CourtyardGround", Vector3(0, -0.16, 0), Vector3(16, 0.32, 16), floor_mat)
    _label(area, "CENTRAL COURTYARD", Vector3(0, 3.1, -1), 0.8)
    for x in [-7.5, 7.5]:
        _box(area, "CourtyardBoundaryA", Vector3(x, 1.8, -4.5), Vector3(0.3, 3.6, 7), concrete)
        _box(area, "CourtyardBoundaryB", Vector3(x, 1.8, 4.5), Vector3(0.3, 3.6, 7), concrete)
        _box(area, "CourtyardSideLintel", Vector3(x, 3.55, 0), Vector3(0.3, 0.5, 2), concrete)
    _box(area, "NorthBoundaryLeft", Vector3(-4.5, 1.8, -8), Vector3(7, 3.6, 0.3), concrete)
    _box(area, "NorthBoundaryRight", Vector3(4.5, 1.8, -8), Vector3(7, 3.6, 0.3), concrete)
    _box(area, "SouthBoundaryLeft", Vector3(-4.5, 1.8, 8), Vector3(7, 3.6, 0.3), concrete)
    _box(area, "SouthBoundaryRight", Vector3(4.5, 1.8, 8), Vector3(7, 3.6, 0.3), concrete)

func _build_cell_block() -> void:
    _room("Cell Block", Vector3(0, 0, -22), Vector2(16, 12), "south")
    for row in range(2):
        var z := -25.0 + row * 6.0
        _box(self, "CellRowDivider", Vector3(0, 1.65, z), Vector3(13, 3.3, 0.18), dark_concrete)
        for i in range(6):
            var x := -6.0 + i * 2.4
            _box(self, "CellPartition", Vector3(x, 1.5, z + (1.3 if row == 0 else -1.3)), Vector3(0.12, 3.0, 2.5), concrete)
            _box(self, "Bunk", Vector3(x + 0.55, 0.55, z + (0.55 if row == 0 else -0.55)), Vector3(1.0, 0.25, 1.8), metal)
            _box(self, "Mattress", Vector3(x + 0.55, 0.72, z + (0.55 if row == 0 else -0.55)), Vector3(0.9, 0.12, 1.65), wood, false)
            _box(self, "Pillow", Vector3(x + 0.55, 0.82, z + (1.18 if row == 0 else -1.18)), Vector3(0.55, 0.12, 0.35), sign_mat, false)
            _box(self, "CellLocker", Vector3(x - 0.65, 1.0, z + (0.55 if row == 0 else -0.55)), Vector3(0.35, 1.8, 0.45), metal)
            _box(self, "CellShelf", Vector3(x + 0.55, 1.35, z), Vector3(0.9, 0.12, 0.25), wood)
            var door_z := -26.25 if row == 0 else -17.75
            _box(self, "CellDoorFrameLeft", Vector3(x - 0.85, 1.2, door_z), Vector3(0.12, 2.4, 0.18), metal)
            _box(self, "CellDoorFrameRight", Vector3(x + 0.85, 1.2, door_z), Vector3(0.12, 2.4, 0.18), metal)
            _make_cell_door(x, door_z, row, i)
            _box(self, "CellToiletBase", Vector3(x - 0.55, 0.28, z + (1.1 if row == 0 else -1.1)), Vector3(0.42, 0.35, 0.5), sign_mat)
            _box(self, "CellToiletTank", Vector3(x - 0.55, 0.75, z + (1.3 if row == 0 else -1.3)), Vector3(0.42, 0.65, 0.2), sign_mat)


func _make_cell_door(center_x: float, front_z: float, row: int, cell_index: int) -> void:
    var trigger := Area3D.new()
    trigger.name = "CellDoor_%d_%d" % [row, cell_index]
    trigger.position = Vector3(center_x, 1.0, front_z)
    trigger.set_script(load("res://scripts/cell_door.gd"))
    add_child(trigger)
    var trigger_shape := CollisionShape3D.new()
    var sphere := SphereShape3D.new()
    sphere.radius = 1.35
    trigger_shape.shape = sphere
    trigger.add_child(trigger_shape)
    var hinge := Node3D.new()
    hinge.name = "Hinge"
    hinge.position = Vector3(-0.78, 0, 0)
    trigger.add_child(hinge)
    trigger.set("door_pivot_path", NodePath("Hinge"))
    var leaf := StaticBody3D.new()
    leaf.name = "DoorLeaf"
    leaf.position = Vector3(0.78, 0, 0)
    hinge.add_child(leaf)
    _box(leaf, "DoorTopRail", Vector3(0, 1.08, 0), Vector3(1.56, 0.12, 0.12), metal)
    _box(leaf, "DoorBottomRail", Vector3(0, -1.08, 0), Vector3(1.56, 0.12, 0.12), metal)
    _box(leaf, "DoorSideRailA", Vector3(-0.72, 0, 0), Vector3(0.12, 2.16, 0.12), metal)
    _box(leaf, "DoorSideRailB", Vector3(0.72, 0, 0), Vector3(0.12, 2.16, 0.12), metal)
    for bar_index in range(7):
        _box(leaf, "DoorBar", Vector3(-0.6 + bar_index * 0.2, 0, 0), Vector3(0.055, 2.0, 0.08), metal)

func _build_room_details() -> void:
    _box(self, "DiningServingHatch", Vector3(14, 1.65, -10.7), Vector3(3.2, 0.8, 0.18), metal)
    _box(self, "DiningMenuBoard", Vector3(14, 2.55, -10.7), Vector3(2.8, 0.8, 0.12), wood)
    _label(self, "DAILY MENU", Vector3(14, 2.5, -10.55), 0.35)
    _box(self, "KitchenPrepTable", Vector3(11.0, 0.9, -15.5), Vector3(2.5, 0.18, 1.2), metal)
    _box(self, "KitchenSink", Vector3(17.0, 0.9, -15.5), Vector3(1.6, 0.22, 0.9), sign_mat)
    _box(self, "KitchenStove", Vector3(11.0, 0.65, -19.0), Vector3(2.2, 0.9, 1.0), dark_concrete)
    for i in range(3):
        _box(self, "FoodCrate", Vector3(16.0 + i * 0.55, 0.35, -19.0), Vector3(0.45, 0.65, 0.5), wood)
    for x in [-17.0, -14.0, -11.0]:
        _box(self, "WorkshopStool", Vector3(x, 0.45, -7.0), Vector3(0.55, 0.8, 0.55), wood)
        _box(self, "LaundryTub", Vector3(x, 0.55, -14.0), Vector3(1.5, 1.0, 1.0), sign_mat)
        _box(self, "FoldedLinen", Vector3(x, 1.0, -18.0), Vector3(0.75, 0.25, 0.75), sign_mat, false)
    _box(self, "WorkshopNoticeBoard", Vector3(-14, 2.1, -10.7), Vector3(3.0, 1.2, 0.12), wood)
    for x in [-3.5, 3.5]:
        _box(self, "OfficeFilingCabinet", Vector3(x, 1.0, 5.5), Vector3(0.8, 2.0, 0.8), metal)
        _box(self, "OfficeChair", Vector3(x * 0.5, 0.5, 8.0), Vector3(0.65, 0.9, 0.65), wood)
    _box(self, "CourtyardNoticeBoard", Vector3(0, 1.7, -11.8), Vector3(2.4, 1.6, 0.15), wood)
    _box(self, "WaterFountain", Vector3(6.0, 0.65, -4.0), Vector3(0.7, 1.3, 0.7), sign_mat)

func _build_cafeteria() -> void:
    _room("Dining Hall", Vector3(14, 0, -5), Vector2(10, 12), "west_north")
    for z in [-8.0, -5.0, -2.0]:
        _box(self, "DiningTable", Vector3(14, 0.85, z), Vector3(5.2, 0.18, 1.0), wood)
        for x in [11.8, 16.2]:
            _box(self, "DiningBench", Vector3(x, 0.48, z), Vector3(0.45, 0.45, 1.8), metal)

func _build_kitchen() -> void:
    _room("Kitchen", Vector3(14, 0, -17), Vector2(10, 8), "south")
    _box(self, "ServingCounter", Vector3(14, 1.0, -18), Vector3(7, 1.0, 1.0), metal)
    _box(self, "KitchenShelf", Vector3(17.5, 1.8, -15), Vector3(0.5, 2.8, 3.0), wood)

func _build_workshop() -> void:
    _room("Workshop", Vector3(-14, 0, -5), Vector2(10, 12), "east_north")
    for z in [-8.0, -4.0, -1.0]:
        _box(self, "WorkshopBench", Vector3(-14, 0.85, z), Vector3(5.0, 0.18, 1.1), wood)
    _box(self, "ToolShelf", Vector3(-17.5, 1.5, -5), Vector3(0.4, 2.4, 5.0), metal)

func _build_laundry() -> void:
    _room("Laundry", Vector3(-14, 0, -17), Vector2(10, 8), "south")
    for x in [-17.0, -14.0, -11.0]:
        _box(self, "LaundryTable", Vector3(x, 0.8, -18), Vector3(2.2, 0.2, 2.0), wood)

func _build_admin() -> void:
    _room("Administration", Vector3(0, 0, 7), Vector2(12, 8), "north_south")
    _box(self, "OfficeDesk", Vector3(0, 0.8, 6), Vector3(4.0, 0.2, 1.6), wood)
    _box(self, "NoticeBoard", Vector3(0, 2.0, 3.2), Vector3(3.0, 1.5, 0.12), dark_concrete)

func _build_yard() -> void:
    var yard := Node3D.new()
    yard.name = "ExerciseYard"
    yard.position = Vector3(0, 0, 18)
    add_child(yard)
    _box(yard, "YardGround", Vector3(0, -0.15, 0), Vector3(22, 0.3, 12), floor_mat)
    _label(yard, "EXERCISE YARD", Vector3(0, 3.0, 0), 0.8)
    for x in [-11.0, 11.0]:
        _box(yard, "YardFenceBase", Vector3(x, 0.6, 0), Vector3(0.3, 1.2, 12), dark_concrete)
        for z in range(-5, 6):
            _box(yard, "FencePost", Vector3(x, 2.0, z), Vector3(0.12, 2.8, 0.12), metal)
    _box(yard, "YardFenceNorthLeft", Vector3(-6, 1.8, -6), Vector3(10, 3.6, 0.25), dark_concrete)
    _box(yard, "YardFenceNorthRight", Vector3(6, 1.8, -6), Vector3(10, 3.6, 0.25), dark_concrete)
    _box(yard, "YardFenceNorthLintel", Vector3(0, 3.55, -6), Vector3(2, 0.5, 0.25), dark_concrete)
    _box(yard, "YardFenceSouth", Vector3(0, 1.8, 6), Vector3(22, 3.6, 0.25), dark_concrete)
    _box(yard, "GardenBed", Vector3(-5, 0.15, 0), Vector3(5, 0.3, 3), wood)
    _box(yard, "GardenSoil", Vector3(-5, 0.34, 0), Vector3(4.7, 0.12, 2.7), _mat(Color(0.20, 0.15, 0.10)), false)
    _box(yard, "Bench", Vector3(5, 0.55, 0), Vector3(3, 0.2, 0.7), wood)

func _build_connectors() -> void:
    _box(self, "CellBlockConnector", Vector3(0, -0.12, -14.5), Vector3(2, 0.24, 3), floor_mat)
    _box(self, "DiningConnector", Vector3(8.5, -0.12, -5), Vector3(3, 0.24, 2), floor_mat)
    _box(self, "WorkshopConnector", Vector3(-8.5, -0.12, -5), Vector3(3, 0.24, 2), floor_mat)
    _box(self, "KitchenConnector", Vector3(14, -0.12, -12.0), Vector3(2, 0.24, 2), floor_mat)
    _box(self, "LaundryConnector", Vector3(-14, -0.12, -12.0), Vector3(2, 0.24, 2), floor_mat)
    _box(self, "AdminConnector", Vector3(0, -0.12, 3.0), Vector3(2, 0.24, 2), floor_mat)
    _box(self, "YardConnector", Vector3(0, -0.12, 12.0), Vector3(2, 0.24, 2), floor_mat)

func _build_courtyard_props() -> void:
    for x in [-5.5, 5.5]:
        _box(self, "CourtyardBench", Vector3(x, 0.55, -5), Vector3(2.8, 0.2, 0.65), wood)
    for x in [-6.0, 6.0]:
        _box(self, "CourtyardLampPost", Vector3(x, 2.2, -10), Vector3(0.16, 4.4, 0.16), metal)
        _box(self, "CourtyardLamp", Vector3(x, 4.5, -10), Vector3(0.65, 0.25, 0.65), sign_mat, false)
