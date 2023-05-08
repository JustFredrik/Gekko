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

#region General Functions =========================================================================

function gekko_update() {
	var _m = __gekko_get_manager();	
	var _keys = ds_map_keys_to_array(_m.componenet_map);
	var _len = array_length(_keys);
	
	// Update Components
	for(var _i = 0; _i < _len; _i++){
		if not _m.componenet_map[? _i].has_parent() {
			_m.componenet_map[? _i].update();
		}
	}
	
	// Update Property Bindings 
	__gekko_update_bindings();
}
function gekko_get_component(_id) {
	var __id = gekko_component_get_id(_id);
	var _m = __gekko_get_manager();
	if ds_map_exists(_m.componenet_map, __id){
		return _m.componenet_map[? __id];
	}
	return undefined;
}
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
function gekko_component_exists(_component_or_id) {
	var _m = __gekko_get_manager();
	var _id = gekko_component_get_id(_component_or_id);
	return ds_map_exists(_m.componenet_map, _id);
}
function gekko_component_get_id(_component_or_id) {
	if is_struct(_component_or_id) {
		return _component_or_id.get_id();
	} else {
		return _component_or_id;
	}
}
function gekko_component_get_x(_component_or_id) {
	var _c = gekko_get_component(_component_or_id);
	return _c.get_x();
}
function gekko_component_get_y(_component_or_id) {
	var _c = gekko_get_component(_component_or_id);
	return _c.get_y();
}
function gekko_component_delete_all() {
	var _m = __gekko_get_manager();
	ds_map_destroy(_m.componenet_map);
	_m.componenet_map = ds_map_create();

}
function gekko_get_time_scale() {
	return 240 / game_get_speed(gamespeed_fps);
}
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
function gekko_get_scale() {
	var _m = __gekko_get_manager();
	return _m.gekko_scale;
}
function gekko_is_safe_springs_enabled() {
	return false;
}
function gekko_is_component(_struct){
	if not is_struct(_struct) {return false}
	return is_instanceof(_struct, GekkoComponentAbstract);
}
		
#endregion

#region Anchor Functions ==========================================================================

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
function gekko_is_spring(_val) {
	return true;
}
#endregion

#region Debug Functions ===========================================================================

function gekko_draw_debug_is_active(){
	var _m = __gekko_get_manager();
	return _m.draw_debug;	
}
function gekko_debug_is_bounding_boxes_enabled(){
	var _m = __gekko_get_manager();
	return _m.debug_enable_bounding_boxes;	
}
function gekko_debug_enable_bounding_boxes(_bool) {
	var _m = __gekko_get_manager();
	_m.debug_enable_bounding_boxes = _bool;
}
function gekko_set_draw_debug(_bool){
	var _m = __gekko_get_manager();
	_m.draw_debug = _bool;
}
	
#endregion
