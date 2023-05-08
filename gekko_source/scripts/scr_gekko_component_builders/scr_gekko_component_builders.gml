

function gekko_create_wrapper(){
	var _component = new GekkoComponentWrapper(noone, GEKKO_ANCHOR.NONE, 0, 0);
	_component.update(); // Initial Update to get the correct position.
	
	__gekko_tracking_add_component(_component);

	return _component;
}


function gekko_create_list(){
	var _component = new GekkoComponentList(noone, GEKKO_ANCHOR.NONE, 0, 0);
	_component.update(); // Initial Update to get the correct position.
	
	__gekko_tracking_add_component(_component);

	return _component;
}



function gekko_create_sprite(_sprite_index, _image_index, _parent=noone, _anchor_offset_x=0, _anchor_offset_y=0){
	var _anchor = gekko_component_exists(_parent) ? GEKKO_ANCHOR.MID_CENTER : GEKKO_ANCHOR.NONE;
	var _component = new GekkoComponentSprite(_sprite_index, _image_index, _anchor, _anchor_offset_x, _anchor_offset_y, _parent);
	_component.update(); // Initial Update to get the correct position.
	
	var _id = __gekko_tracking_add_component(_component);
	//_component.set_id(_id);
	
	// Add component as a child to the parent componenet
	if gekko_component_exists(_parent) { _parent.add_child(_component); }
	
	return _component;
}


function gekko_create_nine_slice(_sprite_index, _image_index, _parent=noone, _anchor_offset_x=0, _anchor_offset_y=0){
	var _anchor = gekko_component_exists(_parent) ? GEKKO_ANCHOR.MID_CENTER : GEKKO_ANCHOR.NONE;
	var _component = new GekkoComponentNineSlice(_sprite_index, _image_index, _anchor, _anchor_offset_x, _anchor_offset_y, _parent);
	_component.update(); // Initial Update to get the correct position.
	
	var _id = __gekko_tracking_add_component(_component);
	//_component.set_id(_id);
	
	// Add component as a child to the parent componenet
	if gekko_component_exists(_parent) { _parent.add_child(_component); }
	
	return _component;
}


function gekko_create_text(){
	var _component = new GekkoComponentText("", GEKKO_FONT_DEFAULT, GEKKO_ANCHOR.NONE, 0, 0, noone);
	_component.update(); // Initial Update to get the correct position.
	
	__gekko_tracking_add_component(_component);

	return _component;
}
