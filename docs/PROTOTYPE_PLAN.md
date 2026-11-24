# Prototype plan

## First playable slice
1. Greybox a small cell block, courtyard, dining room, and gate.
2. Add an XR origin / tracked camera and Quest controller input.
3. Add a ray- or area-based interaction prompt for doors, bread, and NPCs.
4. Add a food HUD and a simple meal pickup / eating loop.
5. Add a patrol schedule and a non-violent caught / checkpoint flow.
6. Add two short environmental puzzles that open a route between areas.

## Suggested scene breakdown
- `scenes/Main.tscn` – bootstrap scene
- `scenes/PrisonBlock.tscn` – cell block and courtyard
- `scenes/InteriorRooms.tscn` – dining room and common room
- `scenes/CityStreet.tscn` – later exploration area
- `scenes/characters/NPC.tscn` – reusable character
- `scenes/items/Bread.tscn` – food pickup

## Art direction
Use original low-poly assets, muted winter colors, readable signage, and fictional place names. Avoid recreating real prison layouts or real-world security procedures.
