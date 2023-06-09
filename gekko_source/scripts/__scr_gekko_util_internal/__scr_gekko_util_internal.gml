

function __gekko_get_manager() {
	static _gekko_struct = {
		componenet_map : ds_map_create(),
		current_generator_id : 0,
		draw_debug : false,
		debug_enable_bounding_boxes : false,
		font_map : ds_map_create(),
		depth_array : [],
		update_array : [],
		gekko_scale : 1,
		binding_array : []
		
	}
	
	return _gekko_struct;
}

// TODO
function __gekko_track_binding(_binding) {
	var _m = __gekko_get_manager();
	array_push(_m.binding_array, _binding);
}


function __gekko_remove_binding(_binding) {
	var _m = __gekko_get_manager();
	
	var _len = array_length(_m.binding_array);
	var _index = -1;
	for(var _i = 0; _i < _len; _i++){
		if _m.binding_array[_i].get_id() == _binding.get_id() {
			_index = _i
			break
		}
	}
	if _index != -1 {
		array_delete(_m.binding_array, _index, 1);
	}
}


function __gekko_create_private_struct(_context) {
	if variable_struct_exists(_context, "__") { return }
	_context.__ = {};
	
}


function __gekko_update_bindings() {
	var _m = __gekko_get_manager();
	
	var _len = array_length(_m.binding_array);
	for(var _i = 0; _i < _len; _i++){
		_m.binding_array[_i].update();
	}
}


function __gekko_tracking_add_component(_component){
	var _m = __gekko_get_manager();
	var _id = __gekko_generate_component_id();
	_component.set_id(_id);
	ds_map_add(_m.componenet_map, _id, _component);
	__gekko_depth_array_add(_component); // Add Component to the the depth Tracking list
	return _id;
}


function __gekko_throw_error(_str) {
	throw (_str);
}


function __gekko_depth_array_add(_component) {
	var _m = __gekko_get_manager();
	var _index = __gekko_array_get_index_bin(_m.depth_array,_component);
	array_insert(_m.depth_array, _index, _component);
	show_debug_message(_index);
}


function __gekko_depth_array_update_pos(_component) {
	__gekko_depth_array_remove(_component);
	__gekko_depth_array_add(_component);
}


function __gekko_depth_array_remove(_component) {
	var _m = __gekko_get_manager();
	array_delete(_m.depth_array, array_get_index(_m.depth_array, _component), 1);
}


function __gekko_array_get_index_bin(_arr, _component) {
	var _l = 0
	var _arr_len = array_length(_arr) - 1;
	var _r = _arr_len;
	var _m
	var _depth = _component.get_depth();
	
	// Check if Depth is outside of Bounds of the Array values
	if ( _r == -1 )						{ return 0  }
	if _depth <= _arr[0].get_depth()	{ return 0  }
	if _depth > _arr[_r].get_depth()	{ return _r + 1 }
	
	var _prev_depth = _arr[0].get_depth();
	var _curr_depth; 
	for(var _i = 1; _i <= _arr_len; _i++){
		_curr_depth = _arr[_i].get_depth();
		if (_prev_depth < _depth && _curr_depth >= _depth){
			return _i;
		}
		_prev_depth = _curr_depth;
	}
	
	
	// Find insertion point with Binary Search
	while _l <= _r {
		_m = floor((_l + _r) /2);
		
		if ( _arr[_m] < _depth ) {
			if ( _arr[max(_m + 1, _arr_len)] > _depth ) {
				return max(_m + 1, _arr_len);
			} else {
				_l = _m + 1;
			}
		} else if ( _arr[_m] > _depth) {
			if ( _arr[_m-1] < _depth ) {
				return _m // Components has unique depth
			} else {
				_r = _m - 1;
			}
		} else {
			return _m // Components with the same depth exists
		}
	}
	show_debug_message("BinSearch Failed! BinSearch Failed! BinSearch Failed! BinSearch Failed! ")
}


function __gekko_generate_component_id(){
	var _m = __gekko_get_manager();
	_m.current_generator_id += 1;
	return _m.current_generator_id - 1;
}


function __gekko_tracking_remove_component(_component_or_id){
	var _m = __gekko_get_manager();
	
	// Component was passed as param
	if is_struct(_component_or_id) {
		ds_map_delete(_m.componenet_map, _component_or_id.id);
	
	// Component Id was passed as param
	} else {
		ds_map_delete(_m.componenet_map, _component_or_id);
	}
}


function __gekko_set_draw_depth(_val){
	var _m = __gekko_get_manager();
	_m.draw_instance.depth = _val;

}


function __gekko_set_draw_instance(_instance) {
	var _m = __gekko_get_manager();
	_m.draw_instance = _instance;
}