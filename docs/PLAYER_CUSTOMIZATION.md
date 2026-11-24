# Quest 3 VR Character Creator

The main scene now contains an XR rig with an `XROrigin3D`, `XRCamera3D`, left and right `XRController3D` nodes, and the world-space character creator. The `scripts/xr_bootstrap.gd` script attempts to initialize OpenXR at startup and switches to the headset camera when initialization succeeds.

## Appearance options
- Hairstyle: short, side part, buzz cut
- Hair colour: dark brown, black, sandy, auburn
- Face: clean shaven, moustache, stubble
- Uniform: olive, navy, charcoal, brown
- Skin tone: light, medium, deep
- Accessories: none, glasses, cap

## Quest 3 setup
1. Open the project in Godot 4 and install/configure the Android export templates.
2. In Project Settings > XR > OpenXR, confirm OpenXR is enabled, Form Factor is Head Mounted, and View Configuration is Stereo. The project file enables OpenXR and XR shaders; restart the editor after changing XR settings.
3. Open the XR Action Map editor. Add Float actions named `creator_select` and `creator_toggle`.
4. Bind `creator_select` to the trigger on both Touch controllers. Bind `creator_toggle` to the left controller menu button. The script reads both actions with `XRController3D.get_float()`.
5. The main scene already instances the XR origin, camera, controller nodes, and creator scene. The left menu button shows/hides the creator. Point either controller at a category and press its trigger to cycle through that category's choices.
6. Configure an Android export preset for Quest 3, then run and test on the headset.

## Implementation notes
- The creator's preview avatar has a visible head; the first-person player avatar keeps its head hidden to avoid camera clipping.
- Appearance selections are applied to the live player model and mirrored on the preview.
- The XR bootstrap leaves the desktop camera active if OpenXR cannot initialize.

## Testing status
The integration is committed but has not been imported/run in Godot or tested on a Quest 3. The XR action bindings and Android export preset still need to be checked in the Godot editor. Do not treat controller input or headset startup as verified until tested on-device.

References: [Godot XR setup](https://docs.godotengine.org/en/stable/tutorials/xr/setting_up_xr.html), [OpenXR settings](https://docs.godotengine.org/en/stable/tutorials/xr/openxr_settings.html), [XR action map](https://docs.godotengine.org/en/stable/tutorials/xr/xr_action_map.html).
