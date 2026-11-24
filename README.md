# 1960: Behind the Iron Walls

A fictional, stylized first-person exploration game for Meta Quest 3, built with Godot 4 and OpenXR.

## Current prototype scope
- Explore a fictional prison courtyard and connected indoor areas.
- Manage a simple food meter; collect bread and speak with characters.
- Interact with NPCs through a small, reusable interaction interface.
- Use non-violent stealth, observation, dialogue, and environmental puzzles to progress.

This starter deliberately contains no weapon or combat system. Guards are represented as patrol / conversation / checkpoint characters; being caught can return the player to a safe checkpoint.

## Player character\nThe player now has a low-poly 1960s prisoner uniform model attached to the player rig. The head is intentionally omitted so it does not obstruct the first-person VR camera. Open the appearance panel with **C** in the current desktop prototype to cycle uniform, shirt, skin, and boot colors. These options are applied to the model at runtime; the VR customization interface still needs to be moved into a world-space panel for Quest 3.\n\n## Project layout
- `scenes/` – game scenes
- `scripts/` – player, interaction, food, and game-state logic
- `assets/` – add original models, textures, audio, and fonts here
- `docs/` – design notes

## Open in Godot
1. Install Godot 4.x with OpenXR support.
2. Clone this repository or open it from GitHub Codespaces.
3. Open the repository folder in Godot; select `project.godot`.
4. Press F6 to run the current main scene, or F5 to run the project.
5. Replace the placeholder geometry with original low-poly environment assets.

## Quest 3 next steps
Enable the OpenXR plugin / XR runtime in Godot, configure an Android export preset, install the Android build templates and Android SDK/JDK, then export an APK. Test on-device using Quest developer mode and a permitted USB / wireless deployment workflow. Codespaces can hold and edit the project, but headset testing and final Android export setup may require device-side or local tooling.

## Controls in this starter
- WASD / left stick: move
- Mouse / right stick: look (desktop prototype)
- E: interact
- F: collect nearby bread

VR controller input and hand tracking are intentionally left as the next implementation milestone.


## Prison map
A connected low-poly prison greybox now includes the central courtyard, cell block, dining hall, kitchen, workshop, laundry, administration, and exercise yard. See [docs/PRISON_MAP.md](docs/PRISON_MAP.md) for the layout and editing notes.
