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
	for(_i = 0; _i <= 100; _i++) { // Create all the Hearts
		_sprite = ui_heart(_hearth_spring);
		_list.add_component(_sprite);
	}
	
	return _list;
}

ui_heart = function(_hearth_spring) {
	var _heart = gekko_create_sprite(gekko_sprite_health, 0)
		//.add_custom_property("health")
		//.set_property_binding("health", EXAMPLE_OBJECT, "hp") // Bind health property to o_game.hp, auto updates.
		//.set_default_animation_style(_hearth_spring)
		.set_sprite(gekko_sprite_health, 0, 0)
		//.set_property_on_decrease("health", function() {		
		//	if get_parent().get_component_index(self) < get_custom_property("health") {
		//		set_property_velocity("y", 12);
		//	} else {
		//		set_image_index(1);
		//	}
	//	})
	//	.set_property_on_increase("health", function() {
	//		if get_parent().get_component_index(self) + 1 == get_custom_property("health") { 
	//			set_image_index(0);
	//			set_property_velocity("y", -20);
	//		}
	//	})
		.set_clickable(true)
		.set_on_click(function(){
			play_animation(gekko_sprite_health_crack, 0, 0.2, false, method(self, function(){
				destroy();
			}));
		});
		
	return _heart
}
	
// ui_heart(new GekkoSpring());
// ui_heart(new GekkoSpring())
// .set_anchor_point(GEKKO_ANCHOR.MID_CENTER);

ui_health_bar();

gekko_set_scale(0.2);
show_debug_overlay(true);
