/*
                                                                                                
                                               @@@@   @@@@                                      
                                                ,@   @@                                         
                                                 @@@@@   @@        @@@@@@@@@     .@@@@@@@@.     
                                                @@@@@%  &@@(      @@@@@@@@@@@@@@@@@@@@@@@@@@    
                         @@@@@*               @@@@@             @@@@@@@@@@@@@@@@@@@@@@@@@@@@/   
                     @@@@@@@@@@@@@          @@@@@@@@@@      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%    
                   *@@@@@@@@@@@@@@@@        /@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      
                   @@@@@@@@@@@@@@@@@@@ #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        
           @@@@@  %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#         
            @@@@  @@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         
      @@@@@    @@@@@      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@         
       @@@,@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           
      .@@/   @@@@@@*  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
     @@@@@@         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/                    
       ,%         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                         
                 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@               @@@          
               (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 @@@         
               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  .@@@@@@@       @@@@       @@@        
              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#  &@@@@@@@@  &@@            @@(       
             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*      @@@@@@@@@  .        @@@       
             @@@@@@@@@@@@@@@@@@@@@@@@%          @@@@@@@@@@@@          @@    @@@       @@@       
            /@@@@@@@@@@@@@@@@@@@@@              @@@@@@@@@@@@           @@@            @@@(      
            @@@@@@@@@@@@@@@@@@@@              *@@@@@@@@@@@                            @@@(      
            @@@@@@@@@@@@@@@@@@@         ,@@@@@@@@@@@(                                 @@@       
            @@@@@@@@@@@@@@@@@@         @@@@@@@@  #(                                  @@@@       
             @@@@@@@@@@@@@@@@@         @@*@@   @@@@@@                               @@@@(       
             @@@@@@@@@@@@@@@@@        @@   @@#   @@                                @@@@@        
              @@@@@@@@@@@@@@@@&    ,@@@@@ #@@@@@                                 .@@@@@         
               @@@@@@@@@@@@@@@@     @@@@    @@@                                 @@@@@@          
                @@@@@@@@@@@@@@@@@                                             @@@@@@%           
                 @@@@@@@@@@@@@@@@@@                                        @@@@@@@@             
                   @@@@@@@@@@@@@@@@@@(                                  @@@@@@@@@               
                     @@@@@@@@@@@@@@@@@@@@                           @@@@@@@@@@@                 
                       @@@@@@@@@@@@@@@@@@@@@@@@,             @@@@@@@@@@@@@@@                    
                          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                       
                              &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                           
                                    &@@@@@@@@@@@@@@@@@@@@@@@@@@#                                


				   █████████  ██████████ █████   ████ █████   ████    ███████   
				  ███░░░░░███░░███░░░░░█░░███   ███░ ░░███   ███░   ███░░░░░███ 
				 ███     ░░░  ░███  █ ░  ░███  ███    ░███  ███    ███     ░░███
				░███          ░██████    ░███████     ░███████    ░███      ░███
				░███    █████ ░███░░█    ░███░░███    ░███░░███   ░███      ░███
				░░███  ░░███  ░███ ░   █ ░███ ░░███   ░███ ░░███  ░░███     ███ 
				 ░░█████████  ██████████ █████ ░░████ █████ ░░████ ░░░███████░  
				  ░░░░░░░░░  ░░░░░░░░░░ ░░░░░   ░░░░ ░░░░░   ░░░░    ░░░░░░░    
                                   
										VERSION 0.0.1
===================================================================================================      
Author	: Fredrik "JustFredrik" Svanholm
Date	: 2023-04-28 (YYYY-MM-DD)
Github	: https://github.com/JustFredrik/Gekko
=================================================================================================*/                                                              

#region Essential Setup Functions =================================================================
// These functions are essential for Gekko to work properly.

///@desc Call this function once every step event from an appropriate game controller.
function gekko_update() {
	var _m = __gekko_get_manager();	
	
	__gekko_inc_step(); // Increment the step tracker.
	

	var _keys = ds_map_keys_to_array(_m.component_map);
	var _len = array_length(_keys);
	
	// Update Components
	for(var _i = 0; _i < _len; _i++){
		var _c = _m.component_map[? _keys[_i]];
		if not _c.has_parent() {
			_c.update();
		}
	}
	
	// Update Property Bindings 
	__gekko_update_bindings();
	
	__gekko_go_through_destroy_array();
}

///@desc Call this function once every draw GUI event from an appropriate game controller.
function gekko_draw() {
	var _s = gekko_get_scale();
	matrix_set(matrix_world, matrix_build(0,0,0,0,0,0,
	_s, _s, 1));
	var _m = __gekko_get_manager();

	var _len = array_length(_m.depth_array) - 1;
	for(var _i = _len; _i >= 0; _i--){
		_m.depth_array[_i].draw();
	}
	matrix_set(matrix_world, matrix_build_identity());
}
	
#endregion

#region Component Builders Functions ==============================================================
/* 
These functions calls on the constructors and creates
new components and returns them. 

NOTE: use these function instead
of using the 'new' keyword and the respective constructor names.
These functions do some additional things that are essential,
this will be changed and later versions will support directly
calling 'new <constructor name>' and the more traditional 
GameMaker syntax of gekko_create_<component name>().
=========================================================*/

///@desc Creates a Gekko Wrapper Component
///@return {Struct.GekkoComponentWrapper}
function gekko_create_wrapper(){
	var _component = new GekkoComponentWrapper(noone, GEKKO_ANCHOR.NONE, 0, 0);
	_component.update(); // Initial Update to get the correct position.
	
	__gekko_tracking_add_component(_component);

	return _component;
}
	
///@desc Creates a Gekko List Component
///@context global
///@return {Struct.GekkoComponentList}
function gekko_create_list(){
	var _component = new GekkoComponentList(noone, GEKKO_ANCHOR.NONE, 0, 0);
	_component.update(); // Initial Update to get the correct position.
	
	__gekko_tracking_add_component(_component);

	return _component;
}
	
///@desc Creates a Gekko List Component
///@param {Asset.GMSprite} sprite_index
///@param {Real}	image_index
///@param {Struct.GekkoComponent}	parent
///@param {Real}	anchor_offset_x
///@param {Real}	anchor_offset_y
///@context global
///@return {Struct.GekkoComponentSprite}
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

///@desc Creates a Gekko Nine-Slice Component
///@param {Asset.GMSprite} sprite_index
///@param {Real}	image_index
///@param {Struct.GekkoComponent}	parent
///@param {Real}	anchor_offset_x
///@param {Real}	anchor_offset_y
///@context global
///@return {Struct.GekkoComponentNineSlice}
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

///@desc Creates a Gekko Text Component
///@context global
///@return {Struct.GekkoComponentText}
function gekko_create_text(){
	var _component = new GekkoComponentText("", GEKKO_FONT_DEFAULT, GEKKO_ANCHOR.NONE, 0, 0, noone);
	_component.update(); // Initial Update to get the correct position.
	
	__gekko_tracking_add_component(_component);

	return _component;
}
	
#endregion

#region General Functions =========================================================================

///@desc Gets a Gekko Component based on the provided id (if a component is provided the same component will be returned)
///@param {Real}	component_or_id		A Gekko component or a component id.
///@return {Struct.GekkoComponent}	A Gekko component with a matching id.
function gekko_get_component(_id) {
	var __id = gekko_component_get_id(_id);
	var _m = __gekko_get_manager();
	if ds_map_exists(_m.component_map, __id){
		return _m.component_map[? __id];
	}
	return undefined;
}
	
///@desc Checks wether a component exists (true) or not (false).
///@param {Real}	component_or_id		A Gekko component or a component id.
///@return {Bool}	wether the component exists (true) or not (false). 
function gekko_component_exists(_component_or_id) {
	var _m = __gekko_get_manager();
	var _id = gekko_component_get_id(_component_or_id);
	return ds_map_exists(_m.component_map, _id);
}
	
///@desc Gets the Id of a gekko component.
///@param {Real}	component_or_id		A Gekko component or a component id.
///@return {Real}	The id of the provided Gekko Component.
function gekko_component_get_id(_component_or_id) {
	if is_struct(_component_or_id) {
		return _component_or_id.get_id();
	} else {
		return _component_or_id;
	}
}
	
///@desc Gets the x value of a gekko component.
///@param {Real}	component_or_id		A Gekko component or a component id.
///@return {Real}	The x value of the provided Gekko Component.
function gekko_component_get_x(_component_or_id) {
	var _c = gekko_get_component(_component_or_id);
	return _c.get_x();
}
	
///@desc Gets the y value of a gekko component.
///@param {Real}	component_or_id		A Gekko component or a component id.
///@return {Real}	The y value of the provided Gekko Component.
function gekko_component_get_y(_component_or_id) {
	var _c = gekko_get_component(_component_or_id);
	return _c.get_y();
}
	
///@desc Deletes all currently existing Gekko Components and clears them from memory.
function gekko_component_delete_all() {
	var _m = __gekko_get_manager();
	ds_map_destroy(_m.component_map);
	_m.component_map = ds_map_create();

}
	
///@desc Gets the time scale of which Gekko is intended to operate at.
///@return	{Real}	Gekko time scale
function gekko_get_time_scale() {
	return 240 / game_get_speed(gamespeed_fps);
	//return 240 / (game_get_speed(gamespeed_fps)) / o_game._delta_speed ;
}
	
///@desc Sets the time scale of which Gekko is intended to operate at, used for games using delta time.
///@param
///@return	
function gekko_set_scale(_scale) {
	static _update_func = function(_c, _s, _f) {
		_c.__.x = _c.__.x * _s;
		_c.__.y = _c.__.y * _s;
		_c.update_x();
		_c.update_y();
		_c.update_target_x();
		_c.update_target_y();
		_c.__.x = _c.get_target_x();
		_c.__.y = _c.get_target_y();
		
		var _len = array_length(_c.__.children);
		for(var _i = 0; _i < _len; _i++){
			_f(_c.__.children[_i], _s, _f);
		}
	}
		
	var _m = __gekko_get_manager();
	var _s = (_m.gekko_scale / _scale);
	_m.gekko_scale = _scale;
	
	// Scale X pos
	var _len = array_length(_m.depth_array) - 1;
	var _c;
	for(var _i = _len; _i >= 0; _i--){
		_c = _m.depth_array[_i];
		
		if not _c.has_parent(){
			_update_func(_c, _s, _update_func);
		}
	}
}
	
///@desc
///@param
///@return	
function gekko_get_scale() {
	var _m = __gekko_get_manager();
	return _m.gekko_scale;
}
	

///@desc NOT IMPLEMENTED: Checks if safe simulation is enabled (true) or not (false) that prevents springs from going unstable.
///@return {Bool}  wether  safe spring simulation is enabled (true) or not (false)
function gekko_is_safe_springs_enabled() {
	return false;
}
	
///@desc
///@param
///@return
function gekko_is_component(_struct){
	if not is_struct(_struct) {return false}
	return is_instanceof(_struct, GekkoComponentAbstract);
}
	
///@desc
///@param
///@return
function gekko_component_is_equal(_c1_or_id, _c2_or_id) {
	var _c1 = gekko_get_component(_c1_or_id);
	var _c2 = gekko_get_component(_c2_or_id);
	return _c1.get_id() == _c2.get_id();
}

#endregion

#region Anchor Functions ==========================================================================

///@desc
///@param
///@return
function gekko_anchor_to_string(_anchor_point){
	switch(_anchor_point) {
		case GEKKO_ANCHOR.TOP_LEFT:
			return "TOP_LEFT";
	
		case GEKKO_ANCHOR.TOP_CENTER:
			return "TOP_CENTER";
			
		case GEKKO_ANCHOR.TOP_RIGHT:
			return "TOP_RIGHT";
		
		// MID ==================================
		case GEKKO_ANCHOR.MID_LEFT:
			return "MID_LEFT";
	
		case GEKKO_ANCHOR.MID_CENTER:
			return "MID_CENTER";
			
		case GEKKO_ANCHOR.MID_RIGHT:
			return "MID_RIGHT";
			
		// BOT ==================================
		case GEKKO_ANCHOR.BOT_LEFT:
			return "BOT_LEFT";
	
		case GEKKO_ANCHOR.BOT_CENTER:
			return "BOT_CENTER";
			
		case GEKKO_ANCHOR.BOT_RIGHT:
			return "BOT_RIGHT";
			
		case GEKKO_ANCHOR.NONE:
			return "NONE";
			
		default:
			return "UNKNOWN_ANCHOR";
		}
}	
	
///@desc
///@param
///@return
function gekko_component_alignment_to_string(_component_alignment){
	switch(_component_alignment) {
		case GEKKO_COMPONENT_ALIGNMENT.TOP_LEFT:
			return "TOP_LEFT";
	
		case GEKKO_COMPONENT_ALIGNMENT.TOP_CENTER:
			return "TOP_CENTER";
			
		case GEKKO_COMPONENT_ALIGNMENT.TOP_RIGHT:
			return "TOP_RIGHT";
		
		// MID ==================================
		case GEKKO_COMPONENT_ALIGNMENT.MID_LEFT:
			return "MID_LEFT";
	
		case GEKKO_COMPONENT_ALIGNMENT.MID_CENTER:
			return "MID_CENTER";
			
		case GEKKO_COMPONENT_ALIGNMENT.MID_RIGHT:
			return "MID_RIGHT";
			
		// BOT ==================================
		case GEKKO_COMPONENT_ALIGNMENT.BOT_LEFT:
			return "BOT_LEFT";
	
		case GEKKO_COMPONENT_ALIGNMENT.BOT_CENTER:
			return "BOT_CENTER";
			
		case GEKKO_COMPONENT_ALIGNMENT.BOT_RIGHT:
			return "BOT_RIGHT";
			
		case GEKKO_COMPONENT_ALIGNMENT.ORIGIN:
			return "ORIGIN";
			
		default:
			return "UNKNOWN_ANCHOR";
		}
}
	
///@desc
///@param
///@return
function gekko_component_alignment_combine(_horizontal_alignment, _vertical_alignment) {
	switch(_horizontal_alignment){
		case GEKKO_COMPONENT_ALIGNMENT_X.LEFT:
			switch(_vertical_alignment){
				case GEKKO_COMPONENT_ALIGNMENT_Y.TOP:
					return GEKKO_COMPONENT_ALIGNMENT.TOP_LEFT
				case GEKKO_COMPONENT_ALIGNMENT_Y.MID:
					return GEKKO_COMPONENT_ALIGNMENT.MID_LEFT
				case GEKKO_COMPONENT_ALIGNMENT_Y.BOT:
					return GEKKO_COMPONENT_ALIGNMENT.BOT_LEFT
			}
		case GEKKO_COMPONENT_ALIGNMENT_X.CENTER:
			switch(_vertical_alignment){
				case GEKKO_COMPONENT_ALIGNMENT_Y.TOP:
					return GEKKO_COMPONENT_ALIGNMENT.TOP_CENTER
				case GEKKO_COMPONENT_ALIGNMENT_Y.MID:
					return GEKKO_COMPONENT_ALIGNMENT.MID_CENTER
				case GEKKO_COMPONENT_ALIGNMENT_Y.BOT:
					return GEKKO_COMPONENT_ALIGNMENT.BOT_CENTER
			}
		case GEKKO_COMPONENT_ALIGNMENT_X.RIGHT:
			switch(_vertical_alignment){
				case GEKKO_COMPONENT_ALIGNMENT_Y.TOP:
					return GEKKO_COMPONENT_ALIGNMENT.TOP_RIGHT
				case GEKKO_COMPONENT_ALIGNMENT_Y.MID:
					return GEKKO_COMPONENT_ALIGNMENT.MID_RIGHT
				case GEKKO_COMPONENT_ALIGNMENT_Y.BOT:
					return GEKKO_COMPONENT_ALIGNMENT.BOT_RIGHT
			}
	}
}
	
///@desc
///@param
///@return
function gekko_get_anchor_horizontal(_anchor_type){
	switch(_anchor_type){
		// TOP ==================================
		case GEKKO_ANCHOR.TOP_LEFT:
			return GEKKO_ANCHOR_HORIZONTAL.LEFT;
	
		case GEKKO_ANCHOR.TOP_CENTER:
			return GEKKO_ANCHOR_HORIZONTAL.CENTER;
			
		case GEKKO_ANCHOR.TOP_RIGHT:
			return GEKKO_ANCHOR_HORIZONTAL.RIGHT;
		
		// MID ==================================
		case GEKKO_ANCHOR.MID_LEFT:
			return GEKKO_ANCHOR_HORIZONTAL.LEFT;
	
		case GEKKO_ANCHOR.MID_CENTER:
			return GEKKO_ANCHOR_HORIZONTAL.CENTER;
			
		case GEKKO_ANCHOR.MID_RIGHT:
			return GEKKO_ANCHOR_HORIZONTAL.RIGHT;
			
		// BOT ==================================
		case GEKKO_ANCHOR.BOT_LEFT:
			return GEKKO_ANCHOR_HORIZONTAL.LEFT;
	
		case GEKKO_ANCHOR.BOT_CENTER:
			return GEKKO_ANCHOR_HORIZONTAL.CENTER;
			
		case GEKKO_ANCHOR.BOT_RIGHT:
			return GEKKO_ANCHOR_HORIZONTAL.RIGHT;
			
		default:
			return GEKKO_ANCHOR_HORIZONTAL.CENTER;
	}
}
	
///@desc
///@param
///@return
function gekko_get_anchor_vertical(_anchor_type){
	switch(_anchor_type){
		// LEFT ==================================
		case GEKKO_ANCHOR.TOP_LEFT:
			return GEKKO_ANCHOR_VERTICAL.TOP;
	
		case GEKKO_ANCHOR.MID_LEFT:
			return GEKKO_ANCHOR_VERTICAL.MID;
			
		case GEKKO_ANCHOR.BOT_LEFT:
			return GEKKO_ANCHOR_VERTICAL.BOT;
		
		// CENTER ===============================
		case GEKKO_ANCHOR.TOP_CENTER:
			return GEKKO_ANCHOR_VERTICAL.TOP;
	
		case GEKKO_ANCHOR.MID_CENTER:
			return GEKKO_ANCHOR_VERTICAL.MID;
			
		case GEKKO_ANCHOR.BOT_CENTER:
			return GEKKO_ANCHOR_VERTICAL.BOT;
			
		// RIGHT ================================
		case GEKKO_ANCHOR.TOP_RIGHT:
			return GEKKO_ANCHOR_VERTICAL.TOP;
	
		case GEKKO_ANCHOR.MID_RIGHT:
			return GEKKO_ANCHOR_VERTICAL.MID;
			
		case GEKKO_ANCHOR.BOT_RIGHT:
			return GEKKO_ANCHOR_VERTICAL.BOT;
			
		default:
			return GEKKO_ANCHOR_HORIZONTAL.CENTER;
	}
}
	
///@desc
///@param
///@return
function gekko_get_global_anchor_point_x(_anchor_point){
	var _s = gekko_get_scale();
	switch(gekko_get_anchor_horizontal(_anchor_point)){
		case GEKKO_ANCHOR_HORIZONTAL.LEFT:
			return 0;
		
		case GEKKO_ANCHOR_HORIZONTAL.CENTER:
			return (display_get_gui_width()/2) / _s;
		
		case GEKKO_ANCHOR_HORIZONTAL.RIGHT:
			return display_get_gui_width() / _s;
			
		default:
			return display_get_gui_width() / _s;
	}
}
	
///@desc
///@param
///@return
function gekko_get_global_anchor_point_y(_anchor_point){
	var _s = gekko_get_scale();
	
	switch(gekko_get_anchor_vertical(_anchor_point)){
		case GEKKO_ANCHOR_VERTICAL.TOP:
			return 0;
		
		case GEKKO_ANCHOR_VERTICAL.MID:
			return (display_get_gui_height()/2) / _s;
		
		case GEKKO_ANCHOR_VERTICAL.BOT:
			return display_get_gui_height() / _s;
			
		default:
			return display_get_gui_height() / _s;
	}
}			
	
///@desc
///@param
///@return
function gekko_get_alignment_horizontal(_component_alignment) {
	switch(_component_alignment){
		case GEKKO_COMPONENT_ALIGNMENT.TOP_LEFT:
			return GEKKO_COMPONENT_ALIGNMENT_X.LEFT;
			
		case GEKKO_COMPONENT_ALIGNMENT.TOP_CENTER:
			return GEKKO_COMPONENT_ALIGNMENT_X.CENTER;
		
		case GEKKO_COMPONENT_ALIGNMENT.TOP_RIGHT:
			return GEKKO_COMPONENT_ALIGNMENT_X.RIGHT;
		
		// MID
		case GEKKO_COMPONENT_ALIGNMENT.MID_LEFT:
			return GEKKO_COMPONENT_ALIGNMENT_X.LEFT;
			
		case GEKKO_COMPONENT_ALIGNMENT.MID_CENTER:
			return GEKKO_COMPONENT_ALIGNMENT_X.CENTER;
		
		case GEKKO_COMPONENT_ALIGNMENT.MID_RIGHT:
			return GEKKO_COMPONENT_ALIGNMENT_X.RIGHT;
			
		// BOT
		case GEKKO_COMPONENT_ALIGNMENT.BOT_LEFT:
			return GEKKO_COMPONENT_ALIGNMENT_X.LEFT;
			
		case GEKKO_COMPONENT_ALIGNMENT.BOT_CENTER:
			return GEKKO_COMPONENT_ALIGNMENT_X.CENTER;
		
		case GEKKO_COMPONENT_ALIGNMENT.BOT_RIGHT:
			return GEKKO_COMPONENT_ALIGNMENT_X.RIGHT;
			
		default:
			return GEKKO_COMPONENT_ALIGNMENT_X.ORIGIN;
	}
}
	
///@desc
///@param
///@return
function gekko_get_alignment_vertical(_component_alignment) {
	switch(_component_alignment){
		case GEKKO_COMPONENT_ALIGNMENT.TOP_LEFT:
			return GEKKO_COMPONENT_ALIGNMENT_Y.TOP;
			
		case GEKKO_COMPONENT_ALIGNMENT.TOP_CENTER:
			return GEKKO_COMPONENT_ALIGNMENT_Y.TOP;
		
		case GEKKO_COMPONENT_ALIGNMENT.TOP_RIGHT:
			return GEKKO_COMPONENT_ALIGNMENT_Y.TOP;
		
		// MID
		case GEKKO_COMPONENT_ALIGNMENT.MID_LEFT:
			return GEKKO_COMPONENT_ALIGNMENT_Y.MID;
			
		case GEKKO_COMPONENT_ALIGNMENT.MID_CENTER:
			return GEKKO_COMPONENT_ALIGNMENT_Y.MID;
		
		case GEKKO_COMPONENT_ALIGNMENT.MID_RIGHT:
			return GEKKO_COMPONENT_ALIGNMENT_Y.MID;
			
		// BOT
		case GEKKO_COMPONENT_ALIGNMENT.BOT_LEFT:
			return GEKKO_COMPONENT_ALIGNMENT_Y.BOT;
			
		case GEKKO_COMPONENT_ALIGNMENT.BOT_CENTER:
			return GEKKO_COMPONENT_ALIGNMENT_Y.BOT;
		
		case GEKKO_COMPONENT_ALIGNMENT.BOT_RIGHT:
			return GEKKO_COMPONENT_ALIGNMENT_Y.BOT;
			
		default:
			return GEKKO_COMPONENT_ALIGNMENT_Y.ORIGIN;
	}
}
	
	
#endregion

#region Spring Functions ==========================================================================

///@desc
///@param
///@return
function gekko_is_spring(_val) {
	return true;
}
	
#endregion

#region Font Functions ============================================================================

///@desc	Creates a new GekkoFont
///@param	{String}	font_name
///@param	{Real}		sprite_index
///@param	{String}	first_character
///@param	{Bool}		proportional
///@param	{Real}		character_seperation
///@context	global 
///@return	{Struct.GekkoFont}
function gekko_font_create(_name ,_sprite, _first_character, _prop, _character_seperation) {
	var _gm_font = font_add_sprite(_sprite, _first_character, _prop, _character_seperation);
	var _m = __gekko_get_manager();
	var _gekko_font = new GekkoFont(_name, _gm_font, _sprite, _first_character, _prop, _character_seperation);
	
	_m.font_map[? _name] = _gekko_font;
	
	return _gekko_font;
}

///@desc	Gets a GekkoFont based on the provided name string.
///@param	{String}	font_name
///@context	global 
///@return	{Struct.GekkoFont}
function gekko_font_get(_name) {
	if is_struct(_name){ return _name } // If name is already a struct just return it
	
	var _m = __gekko_get_manager();
	if ds_map_exists(_m.font_map, _name) {
		return _m.font_map[? _name];
	}
}

///@desc Checks if a Gekko Font exists (true) or not (false).
///@param {String}	font_name
///@context	global 
///@return	{Bool}
function gekko_font_exists(_font_name) {
	var _m = __gekko_get_manager();
	return ds_map_exists(_m.font_map, _font_name);
}

///@desc	Gets an array containing all currently existing GekkoFont names.
///@context	global
///@return	{Array[String]}
function gekko_font_get_names() {
	var _m = __gekko_get_manager();
	return ds_map_keys_to_array(_m.font_map);
}

#endregion ========================================================================================

#region Debug Functions ===========================================================================

///@desc
///@param
///@return
function gekko_draw_debug_is_active(){
	var _m = __gekko_get_manager();
	return _m.draw_debug;	
}
	
///@desc
///@param
///@return
function gekko_debug_is_bounding_boxes_enabled(){
	var _m = __gekko_get_manager();
	return _m.debug_enable_bounding_boxes;	
}
	
///@desc
///@param
///@return
function gekko_debug_enable_bounding_boxes(_bool) {
	var _m = __gekko_get_manager();
	_m.debug_enable_bounding_boxes = _bool;
}
	
///@desc
///@param
///@return
function gekko_set_draw_debug(_bool){
	var _m = __gekko_get_manager();
	_m.draw_debug = _bool;
}
	
#endregion
