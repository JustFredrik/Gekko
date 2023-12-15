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
	follow.set_scale(follow.get_scale() + 0.1);
}		
if mouse_wheel_down() {
	follow.set_scale(follow.get_scale() - 0.1);
}

if keyboard_check_pressed(vk_space) {
	follow.set_visible(! follow.is_visible());
}

data.x = mouse_x;
data.y = mouse_y;