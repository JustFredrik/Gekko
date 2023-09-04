
gekko_update();	// Update UI

// Change hp variable
if keyboard_check_pressed(vk_up) {
	hp = min(hp + 1, 7);
}
if keyboard_check_pressed(vk_down) {
	hp = max(hp - 1, 0);
}
	
if keyboard_check_pressed(vk_delete) {
	hp_list.destroy_hirarchy();
}

if keyboard_check_pressed(vk_enter) {
	gekko_destroy_components(gekko_get_components_by_label("base_heart"));
}
	
// Adjust Gekko UI scale
if mouse_wheel_up() {
	gekko_set_scale(gekko_get_scale() + 0.1);
}		
if mouse_wheel_down() {
	gekko_set_scale(gekko_get_scale() - 0.1);
}