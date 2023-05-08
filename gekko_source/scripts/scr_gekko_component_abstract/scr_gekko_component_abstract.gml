

function GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private ===============================================================================
		__gekko_create_private_struct(self); with(__){
			parent				= _parent;
			anchor_point		= _anchor_point;
			anchor_offset_x		= _anchor_offset_x;
			anchor_offset_y		= _anchor_offset_y;
			offset_absolute		= true;
			children			= [];
			child_alignment		= GEKKO_CHILD_ALIGNMENT.HORIZONTAL;
			component_id		= noone;
			component_alignment = GEKKO_COMPONENT_ALIGNMENT.TOP_LEFT;
			default_animation_style = GEKKO_ANIMATION_STYLE.INSTANT;
			default_spring		= GEKKO_SPRING_DEFAULT;
			lerp_speed			= 1;
			clickable			= false;
			tapable				= false;
			scale				= 1;
			color				= c_white;
			property_spring_map= ds_map_create();
			property_bindings_map = ds_map_create();
			custom_property_map = ds_map_create();
	
	
			x = 0;
			y = 0;
			target_x = x;
			target_y = y;
			velocity_x = 0;
			velocity_y = 0;
	
			target_scale = 1;
			velocity_scale = 0;
	
			component_depth	= 0;
			mouse_pressed	= 0;
		}
		add_animated_properties(["x", "y", "scale", "slice_width"]);
	
		#region Internal Methods ==================================================================

			// Update Methods
			///@ignore
			///@desc INTERNAL: Updates the component.
			static update = function() {
				step();
				update_click();
				update_target_x();
				update_target_y();
				//update_x();
				//update_y();
				update_all_children();
				//update_scale();
				update_animated_properties();
			}	
			
			///@ignore
			static update_click = function() {
				if not is_clickable() and not is_tapable() { return }

				if is_hover() {
			
					// Tap code
					if is_tapable() {
						if mouse_check_button_pressed(mb_left) {
							on_tap();
						}
					}
			
					// Click Code
					if (mouse_check_button_released(mb_left) && (__.mouse_pressed == 1)) {
						on_click();
						__.mouse_pressed = 0;
			
					} elif mouse_check_button(mb_left) {
						if mouse_check_button_pressed(mb_left) {
							__.mouse_pressed = 1;
						}
					} else {
						__.mouse_pressed = 0;
					}
				} else {
					__.mouse_pressed = 0;
				}
			}
			
			///@ignore
			static update_x = function() {
				var _x = get_target_x();
				if ( __.lerp_speed == 1 ) {
					__.x = _x;
				} else {
					__.x = lerp(__.x, _x, __.lerp_speed * gekko_get_time_scale());
				}
			}	
			
			///@ignore
			static update_y = function() {
				var _y = get_target_y();
				if ( __.lerp_speed == 1 ) {
					__.y = _y;
				} else {
					__.y = lerp(__.y, _y, __.lerp_speed * gekko_get_time_scale());
				}
			}
			
			///@ignore
			static update_target_x = function() {
				if __.anchor_point == GEKKO_ANCHOR.NONE { return }
				var _x = get_anchor_point_x();
				_x += get_anchor_offset_x();
		
				_x += get_origin_offset_x();
		
				// Adjust X based on Component Alignment
				switch(gekko_get_alignment_horizontal(__.component_alignment)){
			
					case GEKKO_COMPONENT_ALIGNMENT_X.ORIGIN:
						_x -= get_origin_offset_x();
						break;
				
					case GEKKO_COMPONENT_ALIGNMENT_X.LEFT:
						break;
				
					case GEKKO_COMPONENT_ALIGNMENT_X.CENTER:
						_x -= get_width() / 2.;
						break;
				
					case GEKKO_COMPONENT_ALIGNMENT_X.RIGHT:
						_x -= get_width();
			
					default:
						break
				}
		
				__.target_x = _x
		
			}
			
			///@ignore
			static update_target_y = function() {
				if __.anchor_point == GEKKO_ANCHOR.NONE { return }
				var _y = get_anchor_point_y();
				_y += get_origin_offset_y();
				_y += get_anchor_offset_y();
		
				// Adjust X based on Component Alignment
				switch(gekko_get_alignment_vertical(__.component_alignment)){
			
					case GEKKO_COMPONENT_ALIGNMENT_Y.ORIGIN:
						_y -= get_origin_offset_y();
						break;
			
					case GEKKO_COMPONENT_ALIGNMENT_Y.TOP:
						break;
				
					case GEKKO_COMPONENT_ALIGNMENT_Y.MID:
						_y -= (get_height() / 2.);
						break;
				
					case GEKKO_COMPONENT_ALIGNMENT_Y.BOT:
						_y -= get_height();
						break;
			
					default:
						break
				}
		
				__.target_y = _y
			}
			
			///@ignore
			static update_all_children = function() {
				///@function update_all_children()
		
				var _len = array_length(__.children);
				for(var _i = 0; _i < _len; _i++){
					__.children[_i].update();
				}
			}
			
			///@ignore
			static update_scale = function() {
				if __.lerp_speed >= 1 {
					set_scale(__.target_scale, true);
				} else {
					set_scale(lerp(__.scale, __.target_scale, __.lerp_speed), true);
				}
			}
		
			// Draw Methods
			///@ignore
			static draw = function() {
				var _g_scale = gekko_get_scale();
				var _s = _g_scale * get_scale() * get_parent_scale();
				matrix_set(matrix_world, matrix_build(0,0,0,0,0,0,
				_s, _s, 1));
				var _tmp = draw_get_color();
				draw_set_color(get_color());
				draw_component();
				draw_set_color(_tmp);
				if gekko_draw_debug_is_active() {
					draw_debug();
				}
		
				matrix_set(matrix_world, matrix_build(0,0,0,0,0,0,
				_g_scale, _g_scale, 1));
				if gekko_debug_is_bounding_boxes_enabled(){ draw_bounding_box(); }
	
			}		
			
			///@ignore
			static draw_component = function() {
				return
			}	
			
			///@ignore
			static draw_debug = function() {
				var _x = get_x(), _y = get_y();

				draw_text(_x, _y, y);
				draw_text(_x + 128, _y + 20, gekko_anchor_to_string(__.anchor_point));
				draw_text(_x + 128, _y + 32, parent_exists());
				draw_text(_x + 128, _y - 20, get_id());
				draw_text(_x + 128, _y, gekko_component_alignment_to_string(__.component_alignment));
		
				if is_anchored() {
					draw_sprite(gekko_spr_anchor, 0, get_anchor_point_x(), get_anchor_point_y());
				}
			}			
			
			///@ignore
			static draw_bounding_box = function() {
				draw_rectangle(get_bbox_left(), get_bbox_top(), get_bbox_right(), get_bbox_bottom(), true);
			}	
			
			///@ignore
			static draw_pos = function() {
		
			}
			
			///@ignore
			static __can_create_custom_property = function() {  //TODO
				return true;
			}
			
			///@ignore
			static __create_property_variables = function(_property_name, _val=0) {
				variable_struct_set(self.__, _property_name, _val);
				variable_struct_set(self.__, "target_" + _property_name, _val);
				variable_struct_set(self.__, "velocity_" + _property_name, _val);
			}
				
		#endregion
	#endregion
	
	// Public =====================================================================================
	
		#region Data Binding
		static set_property_binding = function(_property_name, _inst_or_struct, _variable_name) {
			var _new_binding = new GekkoBinding(self, _property_name, _inst_or_struct, _variable_name);
			if property_has_binding(_property_name) {
				remove_property_binding(_property_name);
			}
			__.property_bindings_map[? _property_name] = _new_binding;
		
			return self;		
		}
		static remove_property_binding = function(_property_name) {
			// Remove this check later in place of propper type checking.
			if not is_string(_property_name) {
				throw __gekko_error("property_name is not of type String.");
			}
		
			if ds_map_exists(__.property_bindings_map, _property_name) {
				var _binding = __.property_bindings_map[? + _property_name].destroy();
				ds_map_delete(__.property_bindings_map, _property_name);
			}
		}
		static property_has_binding = function(_property_name){
			return ds_map_exists(__.property_bindings_map, _property_name);
		}
		static set_property_on_change = function(_property_name, _func) {
			variable_struct_set(self, "on_change_" + _property_name, method(self, _func));
			return self;
		}
		static set_property_on_increase = function(_property_name, _func) {
			variable_struct_set(self, "on_increase_" + _property_name, method(self, _func));
			return self;
		}
		static set_property_on_decrease = function(_property_name, _func) {
			variable_struct_set(self, "on_decrease_" + _property_name, method(self, _func));
			return self;
		}
		static remove_property_on_change = function(_property_name, _func) {
			variable_struct_remove(self, "on_change_" + _property_name);
		}
		static remove_property_on_increase = function(_property_name, _func) {
			variable_struct_remove(self, "on_increase_" + _property_name);
		}
		static remove_property_on_decrease = function(_property_name, _func) {
			variable_struct_remove(self, "on_decrease_" + _property_name);
		}
		#endregion
		
		#region Custom Properties
		static add_custom_property = function(_property_name) {
			if not __can_create_custom_property() { __gekko_throw_error("Can't create property of name: " + _property_name + " ") }
			__create_property_variables(_property_name);
			__.custom_property_map[? _property_name] = true;
			return self;
		}
		static set_custom_property = function(_property_name, _val) {
			if is_custom_property(_property_name) {
				variable_struct_set(self.__, _property_name, _val);
				return self;
			} else {
				__gekko_throw_error("Trying to set non-existant custom-property: " + _property_name);
			}
		}
		static get_custom_property = function(_property_name) {
			if is_custom_property(_property_name) {
				return variable_struct_get(self.__, _property_name);
			} else {
				__gekko_throw_error("Trying to get non-existant custom-property: " + _property_name);
			}
		}
		static property_exists = function(_property_name) {
			return variable_struct_exists(self.__, _property_name);
		}
		static is_custom_property = function(_property_name){
			return ds_map_exists(self.__.custom_property_map, _property_name);
		}
	
		// TODO
		static remove_custom_property = function(_property_name) {}
		#endregion
		
		#region Animated properties
		static add_animated_properties = function(_arr) {
			if variable_struct_exists(self.__, "animated_properties"){
				variable_struct_set(self.__, "animated_propertie", array_concat(self.__.animated_properties, _arr))
			} else {
				self.__.animated_properties = _arr;
			}
		}
		static get_animated_properties = function() {
			return __.animated_properties; // Could perhaps copy the array, don't know if it's passed by value or ref in GM rn.
		}	
		static get_property_animation_style = function(_name){
			return __.default_animation_style;
		}
		static get_property_spring = function(_name) {
			if not ds_map_exists(self.__.property_spring_map, _name) {
				return __.default_spring;
			}
			return self.__.property_spring_map[? _name];
		}
		static get_property_target = function(_name) {
			var _target_name = "target_" + _name;
			if variable_struct_exists(self.__, _target_name){
				return variable_struct_get(self.__, _target_name);
			}
		}
			
		static get_property_value = function(_name) {
			if variable_struct_exists(self.__, _name){
				return variable_struct_get(self.__, _name);
			}
		}
		static get_property_velocity = function(_name) {
			var _velocity_name = "velocity_" + _name;
			if variable_struct_exists(self.__, _name){
				return variable_struct_get(self.__, _velocity_name);
			}
		}
		static get_property_lerp_speed = function(_name) {
			return __.lerp_speed;
		}
			
		static set_property_target = function(_name, _val) {
			var _target_name = "target_" + _name;
			variable_struct_set(self.__, _target_name, _val);
			return self;
		}
		static set_property_value = function(_name, _val) {
			var _method_name = "set_" + _name;
			if not variable_struct_exists(self, _method_name) {
				variable_struct_set(self.__, _name, _val);
			}
			var _set_method = variable_struct_get(self, _method_name);
			_set_method(_val);
			return self;
		}
		static set_property_velocity = function(_name, _val) {
			var _velocity_name = "velocity_" + _name;
			variable_struct_set(self.__, _velocity_name, _val);
			return self;
		}
	
		// TODO
		static set_property_animation_style = function(_name, _style) { return self; }
		static set_property_spring = function(_name, _spring) { return self; }
		static set_default_animation_style = function(_val) {
		
			// Spring Animation
			if gekko_is_spring(_val){
				__.default_animation_style = GEKKO_ANIMATION_STYLE.SPRING;
				__.default_spring = _val;
			}
		
			// Lerp or Constant
			if is_numeric(_val) {
				__.lerp_speed = min(1, _val);
				if __.lerp_speed == 1 {
					__.default_animation_style = GEKKO_ANIMATION_STYLE.INSTANT;
				} else {
					__.default_animation_style = GEKKO_ANIMATION_STYLE.LERP;
				}
			}
		
			return self;
		}
		static update_animated_property = function(_name){
			if not variable_struct_exists(self.__, _name) { return }
			var _anim_style = get_property_animation_style(_name);
			switch(_anim_style) {
			
				case GEKKO_ANIMATION_STYLE.INSTANT: 
					set_property_value(_name, get_property_target(_name));
					break
				
				case GEKKO_ANIMATION_STYLE.LERP:
					var _val		= get_property_value(_name);
					var _target		= get_property_target(_name);
					var _lerp_speed = get_property_lerp_speed(_name);
					set_property_value(_name, lerp(_val, _target, _lerp_speed * gekko_get_time_scale()));
					break
				
				case GEKKO_ANIMATION_STYLE.SPRING:
					var _spring = get_property_spring(_name);
					_spring.update(self, _name);
				
			}
		}
		static update_animated_properties = function() {
			static _vars = get_animated_properties();
			var _len = array_length(_vars);
			for(var _i = 0; _i < _len; _i++){
				update_animated_property(_vars[_i])
			}
		}
		#endregion
		
		#region General
		static is_offset_absolute = function() {
			return __.offset_absolute;
		}
		static has_parent = function() {
			return __.parent != noone;
		}
		static remove_parent = function() {
			if has_parent() { __.parent.remove_child(self); }
			__.parent = noone;
		}
		static is_position_inside = function(_x, _y) {
			var _s = gekko_get_scale();
			return (_x >= get_bbox_left() *_s && _x <= get_bbox_right()*_s && _y >= get_bbox_top()*_s && _y <= get_bbox_bottom()*_s );
		}
		static is_hover = function() {
			var _m = __gekko_get_manager();
			var _len = array_length(_m.depth_array);
		
			for(var _i = 0; _i < _len; _i++) {
				if (_m.depth_array[_i] == self) {
					return is_position_inside(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
				}
			
				if _m.depth_array[_i].is_position_inside(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0)) {
					return false;
				}
			}
		}
		static is_clickable = function() {
			return __.clickable;
		}
		static is_tapable = function() {
			return __.tapable;
		}
		static is_anchored = function() {
			return __.anchor_point != GEKKO_ANCHOR.NONE;
		}		
		static add_child = function(_child) {
			if _child.has_parent() {
				_child.remove_parent();
				_child.__.parent = self;	
			}
			array_push(__.children, _child);
			//update();
			//update_all_children();
		}	
		static remove_child = function(_child_or_id) {
			var _len = array_length(__.children);
			for(var i = 0; i < _len; i++){
				if gekko_component_is_equal(__.children[i], _child_or_id){
					__.children[i].__.parent = noone;
					array_delete(__.children, i, 1);
					return
				}
			}
			//throw("Trying to remove a child that is not a child of parent component.");
		}
		static parent_exists = function() {
			return gekko_component_exists(__.parent);
		}
		#endregion
		
		#region Setters
		static set_x = function(_val) {
			__.x = _val;
			return self;
		}
		static set_y = function(_val) {
			__.y = _val;
			return self;
		}
		static set_color = function(_col) {
			__.color = _col;
			return self;
		}
		static set_scale = function(_val) {
		
			var prev_width = get_width();
			var prev_height = get_height();
		
			__.scale = _val 

			var width_diff	= get_width() - prev_width;
			var height_diff = get_height() - prev_height;
		
			// Reposition relative to scale change
			switch(gekko_get_alignment_horizontal(get_component_alignment())){ // Adjust X
				case GEKKO_COMPONENT_ALIGNMENT_X.LEFT:
					break
			
				case GEKKO_COMPONENT_ALIGNMENT_X.CENTER:
					__.x -= width_diff / 2;
					break
			
				case GEKKO_COMPONENT_ALIGNMENT_X.RIGHT:
					__.x -= width_diff;
					break
			}
			switch(gekko_get_alignment_vertical(get_component_alignment())){   // Adjust Y
				case GEKKO_COMPONENT_ALIGNMENT_Y.TOP:
					break
			
				case GEKKO_COMPONENT_ALIGNMENT_Y.MID:
					__.y -= height_diff / 2;
					break
			
				case GEKKO_COMPONENT_ALIGNMENT_Y.BOT:
					__.y -= height_diff;
					break
			}
	
			__.velocity_x = 0;
			__.velocity_y = 0;
		
			return self;
		}		
		static set_target_scale = function(_val) {
			__.target_scale = _val;
		}
		static set_depth = function(_val) {
			var _m = __gekko_get_manager();
			__.component_depth = _val;
			__gekko_depth_array_update_pos(self);
			return self;
		}
		static set_parent = function(_parent) {
			if has_parent() { remove_parent(); }
			__.parent = _parent;
			array_push(__.parent.__.children, self);
			return self;
		}
	
		///@desc	Setting the offset as absolute will always make the offset the same independant of the current GUI scale.
		///@param	{bool} value
		///@return	self
		static set_offset_absolute = function(_bool) {

			__.offset_absolute = _bool;
			return self;
		}
	
		///@desc	Sets the Anchor point with the GEKKO_ANCHOR enum as argument.
		///@param	{Real} anchor_point
		///@return	self
		static set_anchor_point = function(_anchor_point) {
			__.anchor_point = _anchor_point;
			return self;
		}	
		static set_anchor_offset_x = function(_val) {
			__.anchor_offset_x = _val;
			return self;
		}
		static set_anchor_offset_y = function(_val) {
			__.anchor_offset_y = _val;
			return self;
		}
		static set_component_alignment = function(_alignment) {
			__.component_alignment = _alignment;
			return self;
		}
		static set_clickable = function(_bool) {
			__.clickable = _bool;
			return self;
		}
		static set_tapable = function(_bool) {
			__.tapable = _bool;
			return self;
		}
		static set_step = function(_func) {
			step = method(self, _func);
			return self;
		}
		static set_on_click = function(_func) {
			on_click = method(self, _func);
			return self;
		}
		static set_on_tap = function(_func) {
			on_tap = method(self, _func);
			return self;
		}
		static set_lerp_speed = function(_lerpspd){
			set_default_animation_style(_lerpspd)
			return self;
		}
		static set_id = function(_id) {
			__.component_id = _id;
			return self;
		}
		#endregion
		
		#region Getters
		static get_color = function() {
			return __.color;
		}
		static get_scale = function() {
			return __.scale;
		}
		static get_parent_scale = function() {
			if has_parent() {
				return __.parent.__.scale * __.parent.get_parent_scale();
			}
			return 1;
		} 
		static get_depth = function() {
			return __.component_depth;
		}
		static get_component_alignment = function() {
			return __.component_alignment;
		}
		static get_id = function() {
			return __.component_id;
		}
		static get_target_x = function() {
			return __.target_x;
		}
		static get_target_y = function() {
			return __.target_y;
		}
		static get_x = function() {
			return __.x;
		}
		static get_y = function() {
			return __.y;
		}	
		static get_draw_x = function() {
			return get_x() / get_scale() / get_parent_scale();
		}
		static get_draw_y = function() {
			return get_y() / get_scale() / get_parent_scale();
		}
		static get_origin_offset_x = function() {
			return 0;
		}
		static get_origin_offset_y = function() {
			return 0;
		}
		static get_width = function() {
			return get_true_width() * get_scale() * get_parent_scale();
		}
		static get_height = function() {
			return get_true_height() * get_scale() * get_parent_scale();
		}
		static get_true_width = function() {
			return 0;
		}
		static get_true_height = function() {
			return 0;
		}
		static get_parent_id = function() {
			if parent_exists(){
				return __.parent.get_id();
			}
			return -1 // Parent does not exist.
		}	
		static get_parent = function() {
			return __.parent;
		}
		static get_component_anchor_offset_x = function() {
			return 0;
		}			
		static get_component_anchor_offset_y = function() {
			return 0;
		}		
		static get_anchor_offset_x = function() {
			if is_offset_absolute() { return __.anchor_offset_x / gekko_get_scale(); } 
			return __.anchor_offset_x;
		}	
		static get_anchor_offset_y = function() {
			if is_offset_absolute() { return __.anchor_offset_y / gekko_get_scale(); } 
			return __.anchor_offset_y;
		}	
		static get_anchor_point_x = function() {
			if parent_exists() {
				return __.parent.get_child_anchor_x(self);
			} else {
				return gekko_get_global_anchor_point_x(__.anchor_point);
			}
		}
		static get_anchor_point_y = function() {
			if parent_exists() {
				return __.parent.get_child_anchor_y(self);
			} else {
				return gekko_get_global_anchor_point_y(__.anchor_point);
			}
		}	
		static get_child_anchor_x = function(_component) {
			switch(_component.__.anchor_point){
				case GEKKO_ANCHOR.TOP_LEFT:
					return get_bbox_left();
				
				case GEKKO_ANCHOR.MID_LEFT:
					return get_bbox_left();
				
				case GEKKO_ANCHOR.BOT_LEFT:
					return get_bbox_left();
				
				case GEKKO_ANCHOR.TOP_CENTER:
					return get_bbox_left() + ( (get_bbox_right() - get_bbox_left())/ 2 );
				
				case GEKKO_ANCHOR.MID_CENTER:
					return get_bbox_left() + ( (get_bbox_right() - get_bbox_left())/ 2 );
				
				case GEKKO_ANCHOR.BOT_CENTER:
					return get_bbox_left() + ( (get_bbox_right() - get_bbox_left())/ 2 );
				
				case GEKKO_ANCHOR.TOP_RIGHT:
					return get_bbox_right();
				
				case GEKKO_ANCHOR.MID_RIGHT:
					return get_bbox_right();
				
				case GEKKO_ANCHOR.BOT_RIGHT:
					return get_bbox_right();
				
				default:
					return get_x();
				
			}
		}		
		static get_child_anchor_y = function(_component) {
			var _return_val = 0;
			switch(_component.__.anchor_point){
				case GEKKO_ANCHOR.TOP_LEFT:
					_return_val += get_bbox_top(); 
					break;
				
				case GEKKO_ANCHOR.MID_LEFT:
					_return_val += get_bbox_top() + ( (get_bbox_bottom() - get_bbox_top())/ 2 );
					break;
				
				case GEKKO_ANCHOR.BOT_LEFT:
					_return_val += get_bbox_bottom();
					break;
				
				case GEKKO_ANCHOR.TOP_CENTER:
					_return_val += get_bbox_top();
					break;
				
				case GEKKO_ANCHOR.MID_CENTER:
					_return_val += get_bbox_top() + ( (get_bbox_bottom() - get_bbox_top())/ 2 );
					break;
				
				case GEKKO_ANCHOR.BOT_CENTER:
					_return_val += get_bbox_bottom();
					break;
				
				case GEKKO_ANCHOR.TOP_RIGHT:
					_return_val += get_bbox_top();
					break;
				
				case GEKKO_ANCHOR.MID_RIGHT:
					_return_val += get_bbox_top() + ( (get_bbox_bottom() - get_bbox_top())/ 2 );
					break;
				
				case GEKKO_ANCHOR.BOT_RIGHT:
					_return_val += get_bbox_bottom();
					break;
				
				default:
					_return_val += get_x();
					break;
			}
			return _return_val;
		}		
		static get_bbox_left = function() {
			return get_x();
		}
		static get_bbox_right = function() {
			return get_bbox_left() + get_width();
		}	
		static get_bbox_top = function() {
			return get_y();
		}
		static get_bbox_bottom = function() {
			return get_y() + get_height();
		}
		static get_total_scale = function() {
			return get_scale() * get_parent_scale();
		}
		#endregion
		
		#region Event methods
		step = function() {
			return
		}
		on_click = function() {
	
		}
		on_tap = function() {
	
		}
		#endregion
		
}
