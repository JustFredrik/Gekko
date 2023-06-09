// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function GekkoComponentList(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) : GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private ===========================================================
		__gekko_create_private_struct(self); with(__){
		component_array = [];
		seperation = 0;
		list_direction = GEKKO_LIST_DIRECTION.VERTICAL;
		list_component_alignnment = GEKKO_COMPONENT_ALIGNMENT.MID_CENTER;
		padding = 0;
	}	
		
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
			var _c = __.component_array[_index];
			var _offset = __.padding;
			for(var _i = 0; _i < _index; _i++){
				_offset += __.component_array[_i].get_height() + __.seperation;
			}
			return get_y() + _offset;
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
				_offset += __.component_array[_i].get_width() + __.seperation;
			}
			return get_x() + _offset;
		}
		static __get_width_horizontal = function() {
			var _w = min(0, - __.seperation);
			var _len = array_length(__.component_array);
			for(var _i = 0; _i < _len; _i++) {
				_w += __.component_array[_i].get_width();
				_w += __.seperation;
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
				_h += __.seperation;
			}
			return _h;
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
		#endregion
		
	#endregion
	
	// Public =================================================================
		
		// General
		static transpose = function() {
			if __.list_direction == GEKKO_LIST_DIRECTION.VERTICAL {
				__.list_direction = GEKKO_LIST_DIRECTION.HORIZONTAL;
			} else {
				__.list_direction = GEKKO_LIST_DIRECTION.VERTICAL;
			}
			__update_child_alignment();
		
			return self;
		}
		static add_component = function(_component_or_id){
			var _c = gekko_get_component(_component_or_id);
		
			var _alignment = __get_child_alignment();
			_c.set_component_alignment(_alignment)
				.set_anchor_offset_x(0)
				.set_anchor_offset_y(0)
				.set_anchor_point(GEKKO_ANCHOR.TOP_LEFT)
				.set_parent(self);
		
			array_push(__.component_array, _c);
			return self
		}
		static remove_component = function(_component_or_id) {
			var _id		= gekko_component_get_id(_component_or_id);
			var _index = get_component_index(_id);
			if _index != -1 {
				array_delete(__.component_array, _index, 1);
			}
			return self;
		}
		
		// Setters
		static set_seperation = function(_val) {
			__.seperation = max(0, _val);
			return self;
		}
		static set_padding = function(_base) {
			__.padding = _base;
			return self;
		}
		static set_list_direction = function(_direction) {
			if _direction == GEKKO_LIST_DIRECTION.VERTICAL {
				__.list_direction = GEKKO_LIST_DIRECTION.VERTICAL;
			} else {
				__.list_direction = GEKKO_LIST_DIRECTION.HORIZONTAL;
			}
		
			return self;
		}
	
		// Getters
		static get_seperation = function() {
			return __.seperation;
		}
		static get_padding = function() {
		return __.padding;
	}
		static get_list_direction = function() {
		return __.list_direction;
	}
		static get_component_index = function(_component_or_id) {
			var _id		= gekko_component_get_id(_component_or_id);
			var _len	= array_length(__.component_array);
			for(var _i = 0; _i < _len; _i++) {
				if __.component_array[_i].get_id() == _id {
					return _i;
				}
			}
			return -1;
		}

}