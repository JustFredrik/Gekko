/*=========================================================

Gekko Component : List

This component is a container that can hold 
multiple other sub-components and automatically 
organize them. It will highjack the components alignment
and position and automatically place them relative to
the lists x, y position and alignment settings.

=========================================================*/

function GekkoComponentList(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) : GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private =====================================================================
		__gekko_create_private_struct(self); with(__){
		component_array = [];
		seperation = 0;
		list_direction = GEKKO_LIST_DIRECTION.VERTICAL;
		list_component_alignnment = GEKKO_COMPONENT_ALIGNMENT.MID_CENTER;
		padding = 0;
		last_cache = -1;
		cache_child_anchor_x_horizontal = [];
		cache_child_anchor_y_vertical = [];
		cache_width_vertical = 0;
		cache_width_horizontal = 0;
		cache_height_horizontal = 0;
		cache_height_vertical = 0;
		position_map = ds_map_create();
	}	
		
		#region Old Internal Methods
		/*
		static __get_child_alignment = function(){
			if __.list_direction == GEKKO_LIST_DIRECTION.HORIZONTAL {
				return gekko_component_alignment_combine(GEKKO_COMPONENT_ALIGNMENT_X.LEFT, gekko_get_alignment_vertical(__.list_component_alignnment));
			} else {
				return gekko_component_alignment_combine(gekko_get_alignment_horizontal(__.list_component_alignnment), GEKKO_COMPONENT_ALIGNMENT_Y.TOP );
			}
		}	
		static __update_child_alignment = function(){
			var _len	= array_length(__.component_array);
			var _alignment =  __get_child_alignment();
			for(var _i = 0; _i < _len; _i++) {
				__.component_array[_i].set_component_alignment(_alignment);
			}
		}
		
		static __get_child_anchor_y_vertical = function(_component_or_id) {
			var _index = get_component_index(_component_or_id);
			var _c = __.component_array[_index];
			var _offset = __.padding;
			for(var _i = 0; _i < _index; _i++){
				_offset += __.component_array[_i].get_height();
				_offset += (__.component_array[_i].get_target_scale() != 0) * __.seperation;
			}
			return get_y() + _offset - (__.seperation * 0.5 * (__.component_array[_index].get_target_scale() == 0));
		}
		static __get_child_anchor_y_horizontal = function(_component_or_id) {
			//var _c = gekko_get_component(_component_or_id);
		
			switch(gekko_get_alignment_vertical(__.list_component_alignnment)) {
				case GEKKO_COMPONENT_ALIGNMENT_Y.TOP:
					return get_y();
			
				case GEKKO_COMPONENT_ALIGNMENT_Y.MID:
					return get_y() + (get_height() / 2. );
				
				case GEKKO_COMPONENT_ALIGNMENT_Y.BOT:
					return get_y() + get_height();
			}
		}	
		static __get_child_anchor_x_vertical = function(_component_or_id) {
			//var _c = gekko_get_component(_component_or_id);
		
			switch(gekko_get_alignment_horizontal(__.list_component_alignnment)) {
				case GEKKO_COMPONENT_ALIGNMENT_X.LEFT:
					return get_x();
			
				case GEKKO_COMPONENT_ALIGNMENT_X.CENTER:
					return get_x() + (get_width() / 2. );
				
				case GEKKO_COMPONENT_ALIGNMENT_X.RIGHT:
					return get_y() + get_width();
			}
		}
		static __get_child_anchor_x_horizontal = function(_component_or_id) {
			var _index = get_component_index(_component_or_id);
			var _c = __.component_array[_index];
			var _offset = __.padding;
			for(var _i = 0; _i < _index; _i++){
				_offset += __.component_array[_i].get_width();
				_offset += (__.component_array[_i].get_target_scale() != 0) * __.seperation;
			}
			return get_x() + _offset - (__.seperation * 0.5 * (__.component_array[_index].get_target_scale() == 0));
		}
		
		static __get_width_horizontal = function() {
			var _w = min(0, - __.seperation);
			var _len = array_length(__.component_array);
			for(var _i = 0; _i < _len; _i++) {
				_w += __.component_array[_i].get_width();
				_w += __.seperation * (__.component_array[_i].get_target_scale() != 0);
			}
			return _w;
		}
		static __get_width_vertical = function() {
			var _w = 0;
			var _len = array_length(__.component_array);
			for(var _i = 0; _i < _len; _i++) {
				_w = max(_w, __.component_array[_i].get_width());
			}
			return _w;
		}	
		static __get_height_horizontal = function() {
			var _h = 0;
			var _len = array_length(__.component_array); 
			for(var _i = 0; _i < _len; _i++) {
				_h = max(_h, __.component_array[_i].get_height());
			}
			return _h;
		}
		static __get_height_vertical = function() {
			var _h = min(0, - __.seperation);
			var _len = array_length( __.component_array);
			for(var _i = 0; _i < _len; _i++) {
				_h += __.component_array[_i].get_height();
				_h += __.seperation * (__.component_array[_i].get_target_scale() != 0);
			}
			return _h;
		}
		*/
		#endregion
		
		#region Internal Methods
		
		static __get_child_alignment = function(){
			if __.list_direction == GEKKO_LIST_DIRECTION.HORIZONTAL {
				return gekko_component_alignment_combine(GEKKO_COMPONENT_ALIGNMENT_X.LEFT, gekko_get_alignment_vertical(__.list_component_alignnment));
			} else {
				return gekko_component_alignment_combine(gekko_get_alignment_horizontal(__.list_component_alignnment), GEKKO_COMPONENT_ALIGNMENT_Y.TOP );
			}
		}	
		static __update_child_alignment = function(){
			var _len	= array_length(__.component_array);
			var _alignment =  __get_child_alignment();
			for(var _i = 0; _i < _len; _i++) {
				__.component_array[_i].set_component_alignment(_alignment);
			}
		}
		
		static __get_child_anchor_y_vertical = function(_component_or_id) {
			var _index = get_component_index(_component_or_id);
			if __.last_cache != __gekko_get_step() {
				__update_child_and_size_cache();
			}
			return __.cache_child_anchor_y_vertical[_index]; 
		}
		static __get_child_anchor_y_horizontal = function(_component_or_id) {
			//var _c = gekko_get_component(_component_or_id);
		
			switch(gekko_get_alignment_vertical(__.list_component_alignnment)) {
				case GEKKO_COMPONENT_ALIGNMENT_Y.TOP:
					return get_y();
			
				case GEKKO_COMPONENT_ALIGNMENT_Y.MID:
					return get_y() + (get_height() / 2. );
				
				case GEKKO_COMPONENT_ALIGNMENT_Y.BOT:
					return get_y() + get_height();
			}
		}	
		static __get_child_anchor_x_vertical = function(_component_or_id) {
			//var _c = gekko_get_component(_component_or_id);
		
			switch(gekko_get_alignment_horizontal(__.list_component_alignnment)) {
				case GEKKO_COMPONENT_ALIGNMENT_X.LEFT:
					return get_x();
			
				case GEKKO_COMPONENT_ALIGNMENT_X.CENTER:
					return get_x() + (get_width() / 2. );
				
				case GEKKO_COMPONENT_ALIGNMENT_X.RIGHT:
					return get_y() + get_width();
			}
		}
		static __get_child_anchor_x_horizontal = function(_component_or_id) {
			var _index = get_component_index(_component_or_id);
			if __.last_cache != __gekko_get_step() {
				__update_child_and_size_cache();
			}
			return __.cache_child_anchor_x_horizontal[_index]; 
		}
		
		static __update_child_and_size_cache = function() {
			__.last_cache = __gekko_get_step();
			if get_list_direction() == GEKKO_LIST_DIRECTION.HORIZONTAL {
				__update_child_and_size_cache_x_horizontal();				
			} else {
				__update_child_and_size_cache_y_vertical();	
			}
		}
		
		static __update_child_and_size_cache_x_horizontal = function() {
			var _len = array_length(__.component_array);
			var _comp_arr = __.component_array;
			var _sep = __.seperation; var _padding = __.padding;
			var _offset = _padding + get_x();
			if _len <= 0 {return }
			
			__.cache_child_anchor_x_horizontal[0] = _offset - (_sep * 0.5 * (_comp_arr[0].get_target_scale() == 0));;
			__.cache_height_horizontal = max(0, _comp_arr[0].get_height());
			
			for(var _i = 1; _i < _len; _i++) {	
				_offset += _comp_arr[_i].get_width();
				_offset += (_comp_arr[_i].get_target_scale() != 0) * _sep;
				__.cache_child_anchor_x_horizontal[_i] = _offset - (_sep * 0.5 * (_comp_arr[_i].get_target_scale() == 0));
				__.cache_height_horizontal = max(__.cache_height_horizontal, _comp_arr[_i].get_height());
			}
			__.cache_width_horizontal = _offset - _padding;
		}	
		static __update_child_and_size_cache_y_vertical = function() {
			var _len = array_length(__.component_array);
			var _comp_arr = __.component_array;
			var _sep = __.seperation; var _padding = __.padding;
			var _offset = _padding + get_y();
			if _len <= 0 {return }
			
			__.cache_child_anchor_y_vertical[0] = _offset - (_sep * 0.5 * (_comp_arr[0].get_target_scale() == 0));;
			__.cache_width_vertical = max(0, _comp_arr[0].get_width());
			
			for(var _i = 1; _i < _len; _i++) {	
				_offset += _comp_arr[_i].get_height();
				_offset += (_comp_arr[_i].get_target_scale() != 0) * _sep;
				__.cache_child_anchor_y_vertical[_i] = _offset - (_sep * 0.5 * (_comp_arr[_i].get_target_scale() == 0));
				__.cache_width_vertical = max(__.cache_width_vertical, _comp_arr[_i].get_width());
			}
			__.cache_height_vertical = _offset - _padding;
		}
		
		static __get_width_horizontal = function() {
			if __.last_cache != __gekko_get_step() {
				__update_child_and_size_cache();
			}
			return __.cache_width_horizontal;
		}	
		static __get_width_vertical = function() {
			if __.last_cache != __gekko_get_step() {
				__update_child_and_size_cache();
			}
			return __.cache_width_vertical;
		}	
		static __get_height_horizontal = function() {
			if __.last_cache != __gekko_get_step() {
				__update_child_and_size_cache();
			}
			return __.cache_height_horizontal;
		}
		static __get_height_vertical = function() {
			if __.last_cache != __gekko_get_step() {
				__update_child_and_size_cache();
			}
			return __.cache_height_vertical;
		}
	
		#endregion
		
		#region Parent Method Overrides
		static get_width = function() {
		
			if (__.list_direction == GEKKO_LIST_DIRECTION.HORIZONTAL) {
				return __get_width_horizontal() + __.padding * 2;		
			} else {
				return __get_width_vertical() + __.padding * 2;
			}
		
		}
		static get_height = function(){
			if (__.list_direction == GEKKO_LIST_DIRECTION.HORIZONTAL) {
				return __get_height_horizontal() + __.padding * 2;		
			} else {
				return __get_height_vertical() + __.padding * 2;
			}
		}	
		static get_bbox_left = function(){
			return get_x();
		}
		static get_bbox_right = function(){
			return get_x() + get_width();
		}
		static get_bbox_top = function(){
			return get_y();
		}
		static get_bbox_bottom = function(){
			return get_y() + get_height();
		}
		static get_child_anchor_y = function(_component_or_id) {
			if (__.list_direction == GEKKO_LIST_DIRECTION.HORIZONTAL) {
				return __get_child_anchor_y_horizontal(_component_or_id);
			} else {
				return __get_child_anchor_y_vertical(_component_or_id);
			}
		}
		static get_child_anchor_x = function(_component_or_id) {
			if (__.list_direction == GEKKO_LIST_DIRECTION.HORIZONTAL) {
				return __get_child_anchor_x_horizontal(_component_or_id);
			} else {
				return __get_child_anchor_x_vertical(_component_or_id);
			}
		}
		static remove_child = function(_child_or_id) {
			
			// Remove from children
			var _len = array_length(__.children);
			for(var i = 0; i < _len; i++){
				if gekko_component_is_equal(__.children[i], _child_or_id){
					__.children[i].__.parent = noone;
					array_delete(__.children, i, 1);
					break
				}
			}
			
			// Remove from component array
			var _len = array_length(__.component_array);
			for(var i = 0; i < _len; i++) {
				if gekko_component_is_equal(__.component_array[i], _child_or_id){
					array_delete(__.component_array, i, 1);
					return
				}
			}
			//throw("Trying to remove a child that is not a child of parent component.");
		}
		#endregion
		
	#endregion
	
	// Public ===========================================================================
		
		#region General ===================================
		
		///@desc Transpose the list between a horizontal and vertical list.
		///@context GekkoComponentList
		///@return {Struct.GekkoComponentList self
		static transpose = function() {
			if __.list_direction == GEKKO_LIST_DIRECTION.VERTICAL {
				__.list_direction = GEKKO_LIST_DIRECTION.HORIZONTAL;
			} else {
				__.list_direction = GEKKO_LIST_DIRECTION.VERTICAL;
			}
			__update_child_alignment();
		
			return self;
		}
			
		///@desc Adds a component to the end of the list.
		///@context GekkoComponentList
		///@return {Struct.GekkoComponentList} self
		static add_component = function(_component_or_id){
			var _c = gekko_get_component(_component_or_id);
		
			var _alignment = __get_child_alignment();
			_c.set_component_alignment(_alignment)
				.set_anchor_offset_x(0)
				.set_anchor_offset_y(0)
				.set_anchor_point(GEKKO_ANCHOR.TOP_LEFT)
				.set_parent(self);
			array_push(__.component_array, _c);
			array_push(__.cache_child_anchor_x_horizontal, 0);
			array_push(__.cache_child_anchor_y_vertical, 0);
			__.position_map[? _c.get_id()] = array_length(__.component_array) - 1;
			return self
		}
			
		///@desc Inserts a component to the list at the provided index.
		///@param {Struct.GekkoComponentList | Real} component_or_id
		///@context GekkoComponentList
		///@return {Struct.GekkoComponentList} self
		static insert_component = function(_component_or_id, _index){
			var _c = gekko_get_component(_component_or_id);
		
			var _alignment = __get_child_alignment();
			_c.set_component_alignment(_alignment)
				.set_anchor_offset_x(0)
				.set_anchor_offset_y(0)
				.set_anchor_point(GEKKO_ANCHOR.TOP_LEFT)
				.set_parent(self);
			array_push(__.component_array, _c);
			array_push(__.cache_child_anchor_x_horizontal, undefined);
			array_push(__.cache_child_anchor_y_vertical, undefined);
			return self
		}
			
		///@desc Remove a component from the list.
		///@param {Struct.GekkoComponentList | Real} component_or_id
		///@context GekkoComponentList
		///@return {Struct.GekkoComponentList} self
		static remove_component = function(_component_or_id) {
			var _id		= gekko_component_get_id(_component_or_id);
			var _index = get_component_index(_id);
			if _index != -1 {
				__.component_array[_index].remove_parent();
				//array_delete(__.component_array, _index, 1); // Why is this removed ??
				array_delete(__.cache_child_anchor_x_horizontal, _index, 1);
				array_delete(__.cache_child_anchor_y_vertical, _index, 1);
			}
			return self;
		}
			
		#endregion
		
		#region Setters ===================================
		
		///@desc Sets the pixel seperation value between the components in the list.
		///@param {Real} value
		///@context GekkoComponentList
		///@return {Struct.GekkoComponentList} self
		static set_seperation = function(_val) {
			__.seperation = max(0, _val);
			return self;
		}
			
		///@desc Sets the padding of the list. How much the list should add padding around it's components.
		///@param {Real} value
		///@context GekkoComponentList
		///@return {Struct.GekkoComponentList} self	
		static set_padding = function(_base) {
			__.padding = _base;
			return self;
		}
			
		///@desc Sets the direction of the list vertical (true) or horizontal (false).
		///@param {bool} value
		///@context GekkoComponentList
		///@return {Struct.GekkoComponentList} self	
		static set_list_direction = function(_direction) {
			if _direction == GEKKO_LIST_DIRECTION.VERTICAL {
				__.list_direction = GEKKO_LIST_DIRECTION.VERTICAL;
			} else {
				__.list_direction = GEKKO_LIST_DIRECTION.HORIZONTAL;
			}
		
			return self;
		}
	
		#endregion
		
		#region Getters ===================================
		
		///@desc	Gets the pixel seperation value between the components in the list.
		///@context GekkoComponentList
		///@return	{Real}	value
		static get_seperation = function() {
			return __.seperation;
		}
		
		///@desc	Gets the padding of the list. How much the list should add padding around it's components.
		///@context GekkoComponentList
		///@return	{Real}	value
		static get_padding = function() {
		return __.padding;
	}
			
		///@desc	Gets the direction of the list vertical (true) or horizontal (false).
		///@context GekkoComponentList
		///@return	{Bool}	value 
		static get_list_direction = function() {
		return __.list_direction;
	}
		
		///@desc	Gets the index in the list of a component (-1 if it isn't in the list).
		///@param	{Struct.GekkoComponent | Real}	component_or_id
		///@context GekkoComponentList
		///@return	{Real}	index
		static get_component_index = function(_component_or_id) {
			var _id		= gekko_component_get_id(_component_or_id);
			return __.position_map[? _id]
			var _len	= array_length(__.component_array);
			for(var _i = 0; _i < _len; _i++) {
				if __.component_array[_i].get_id() == _id {
					return _i;
				}
			}
			return -1;
		}
			
		#endregion
		
}
