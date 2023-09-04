// set instance variable to show binding.
hp = 7;


// Create Healthbar

ui_health_bar = function() {
	
	var _list = gekko_create_list() // Create a list to store all hearts
	.transpose()
	.set_anchor_point(GEKKO_ANCHOR.MID_CENTER)
	.set_component_alignment(GEKKO_COMPONENT_ALIGNMENT.MID_CENTER)
	.set_seperation(16);
	
	var _sprite;
	var _hearth_spring = new GekkoSpring(); // Use the same spring animations for all hearts
	for(_i = 0; _i <= 6; _i++) { // Create all the Hearts
		_sprite = gekko_create_sprite(gekko_sprite_health, 0)
		.set_image_speed(0)
		.label_add("base_heart")
		.add_custom_property("health")
		.set_property_binding("health", EXAMPLE_OBJECT, "hp") // Bind health property to o_game.hp, auto updates.
		.set_default_animation_style(_hearth_spring)
		.set_property_on_decrease("health", function() {		
			if get_parent().get_component_index(self) < get_custom_property("health") {
				set_property_velocity("y", 12);
			} else {
				set_image_index(1);
			}
		})
		.set_property_on_increase("health", function() {
			if get_parent().get_component_index(self) + 1 == get_custom_property("health") { 
				set_image_index(0);
				set_property_velocity("y", -20);
			}
		});
		_list.add_component(_sprite);
	}
	return _list;
}

hp_list = ui_health_bar();

gekko_debug_enable_bounding_boxes(true);