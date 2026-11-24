# Quest 3 VR Character Creator

The character creator is a world-space 3D panel intended to be added beneath the game's `XROrigin3D` node.

## Appearance options
- Hairstyle: short, side part, buzz cut
- Hair colour: dark brown, black, sandy, auburn
- Face: clean shaven, moustache, stubble
- Uniform: olive, navy, charcoal, brown
- Skin tone: light, medium, deep
- Accessories: none, glasses, cap

## Scene setup
1. Open `scenes/ui/VRCharacterCreator.tscn` in Godot 4.
2. Add the scene beneath the XR rig so its panel appears in front of the player.
3. In the Inspector, set `left_controller_path` and `right_controller_path` to the rig's left and right `XRController3D` nodes.
4. Set `player_model_path` to the player model node. The default path assumes the creator is a child of the XR origin and the player is a sibling branch; adjust it to match the actual rig.
5. In Project Settings > XR > OpenXR, create a Bool action named `creator_select` and bind it to the trigger input in the Touch controller interaction profile. Also create a Bool action named `creator_toggle` and bind it to the left controller menu button. The script reads these actions through `XRController3D.get_float()`; OpenXR supports reading Bool actions through the float accessor. Use the left menu button to show or hide the creator, then point either controller at an option and squeeze its trigger to cycle that setting.
6. Enable OpenXR and configure the Quest 3 Android export preset before device testing.

The creator uses controller pointing rays and a trigger press. Its preview avatar has a visible head; the first-person player avatar keeps its head hidden to avoid camera clipping. The selected appearance is copied to the live player model when an option is changed.

## Testing status
The files are committed as a starter implementation, but the scene has not yet been imported or run in Godot and has not been tested on a Quest 3. Confirm the node paths and action binding in the actual XR rig before treating controller input as verified.
