# 1960: Behind the Iron Walls

A fictional, stylized first-person exploration game for Meta Quest 3, built with Godot 4 and OpenXR.

## Current prototype scope
- Explore a fictional prison courtyard and connected indoor areas.
- Manage a simple food meter; collect bread and speak with characters.
- Interact with NPCs through a small, reusable interaction interface.
- Use non-violent stealth, observation, dialogue, and environmental puzzles to progress.

This starter deliberately contains no weapon or combat system. Guards are represented as patrol / conversation / checkpoint characters; being caught can return the player to a safe checkpoint.

## Main menu
The project now opens to a front-end menu with **Start New Shift**, **Controls & Help**, and **Quit Game**. Start New Shift loads the prison gameplay scene. The menu uses a restrained, worn-industrial look to fit the 1960 setting.

## Player character
The player now has a low-poly 1960s prisoner uniform model attached to the player rig. The head is intentionally omitted so it does not obstruct the first-person VR camera. Open the appearance panel with **C** in the current desktop prototype to cycle uniform, shirt, skin, and boot colors. These options are applied to the model at runtime.

## Project layout
- `scenes/` – game scenes
- `scripts/` – player, interaction, food, and game-state logic
- `assets/` – add original models, textures, audio, and fonts here
- `docs/` – design notes

## Open in Godot
1. Install Godot 4.x with OpenXR support.
2. Clone this repository or open it from GitHub Codespaces.
3. Open the repository folder in Godot; select `project.godot`.
4. Press F5 to run the project and open the main menu.
5. Select **Start New Shift** to load the prison map.

## Controls in this starter
- WASD / left stick: move
- Mouse / right stick: look (desktop prototype)
- E: interact
- F: collect nearby bread
- C: customize character
- N: next workday

VR controller input and hand tracking are still being developed; some interactions currently use desktop controls.

## Prison map
A connected low-poly prison greybox now includes the central courtyard, cell block, dining hall, kitchen, workshop, laundry, administration, and exercise yard. See [docs/PRISON_MAP.md](docs/PRISON_MAP.md) for the layout and editing notes.

## Prison interiors, doors, and characters
Cell doors now swing open and closed when targeted and interacted with. Cell spaces have bunks, mattresses, pillows, lockers, shelves, and basic washroom fixtures. Dining, kitchen, workshop, laundry, and administration spaces have additional furniture and props. Seven named low-poly NPCs are placed around the complex and can be spoken to using the existing interaction system.
