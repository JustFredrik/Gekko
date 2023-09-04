/*=========================================================

Gekko Component : Abstract (Root Parent Class)

This is the parent class for all components.
This contains all core functionality of the Gekko
Components.

=========================================================*/

function GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private ===============================================================================
		__gekko_create_private_struct(self); with(__) {
			parent				= _parent;
			anchor_point		= _anchor_point;
			anchor_offset_x		= _anchor_offset_x;
			anchor_offset_y		= _anchor_offset_y;
			offset_absolute		= false;
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
			property_spring_map = ds_map_create();
			property_bindings_map = ds_map_create();
			property_animation_style = ds_map_create();
			custom_property_map = ds_map_create();
			property_lerp_speed = ds_map_create();
			label_map			= ds_map_create();
			
			//Shader Variables
			is_using_shader = false;
			shader_uniforms = {};
			active_shader = -1;
			
			visible = true;
	
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
			
			target_anchor_offset_x = anchor_offset_x;
			target_anchor_offset_y = anchor_offset_y;
			velocity_anchor_offset_x = 0;
			velocity_anchor_offset_y = 0;
		}
		add_animated_properties(["x", "y", "scale", "slice_width", "anchor_offset_x", "anchor_offset_y"]);
	
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
				__component_special_update();
			}	
			
			static __component_special_update = function() {
			}
			
			///@ignore
			///@desc Function that runs internally each step to check if component has been clicked.
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
			
					} else if mouse_check_button(mb_left) {
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
				if not __.visible { return }
				
				// Apply Scaling
				var _g_scale = gekko_get_scale();
				var _s = _g_scale * get_scale() * get_parent_scale();
				matrix_set(matrix_world, matrix_build(0,0,0,0,0,0,
				_s, _s, 1));
				var _tmp = draw_get_color();
				//draw_set_color(get_color());
				
				// Apply Shader
				if __.is_using_shader {
					shader_set(__.active_shader);
					__apply_shader_uniforms();
				}
				
				draw_component(); // ======= DRAW COMPONENT  ================
				
				// Reset everything for the next component
				if __.is_using_shader { shader_reset();	}
				
				//draw_set_color(_tmp);
				if gekko_draw_debug_is_active() { // Debug Rendering
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
			static __apply_shader_uniforms = function() {
				var _uniforms = __.shader_uniforms;
				var _uniform_names = variable_struct_get_names(__.shader_uniforms);
				var _getter, _uniform_data;
				var _len = array_length(_uniform_names);
				for(var _i = 0; _i < _len; _i++){
					_uniform_data = variable_struct_get(_uniforms, _uniform_names[_i]);
					var _set_function = self.__get_shader_set_function(_uniform_data);
					_set_function(_uniform_names[_i], _uniform_data[1]);
				}
				
			}
			
			///@ignore
			static __get_shader_set_function = function(_uniform_data) {
				var _type = _uniform_data[0];
				switch(_type) {
					case GEKKO_INT:
						return shader_set_uniform_i;
					
					case GEKKO_INT_ARRAY:
						return shader_set_uniform_i_array;
						
					case GEKKO_FLOAT:
						return shader_set_uniform_f;
						
					case GEKKO_FLOAT_ARRAY:
						return shader_set_uniform_f_array;
						
					case GEKKO_MATRIX:
						return shader_set_uniform_matrix;
					
					case GEKKO_MATRIX_ARRAY:
						return shader_set_uniform_matrix_array;
				}
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
				

			///@ignore
			static __tear_down_private_struct = function() {
				var _names = [	"property_spring_map", 
								"property_bindings_map", 
								"custom_property_map", 
								"property_animation_style", 
								"property_lerp_speed",
								"label_map"];
				var _len = array_length(_names);
				for(var _i = 0; _i < _len; _i++){
					var _v = variable_struct_get(self.__, _names[_i]);
					ds_map_destroy(_v);
				}
				delete __;
			}
				

		#endregion
	#endregion
	
	// Public =====================================================================================
	
		#region Data Binding ==============================
		
		///@desc	Gets an array of all properties that currently have bindings.
		///@context GekkoComponentAbstract
		///@return	{Array[String]} property_bindings
		static get_property_bindings = function() {
			return ds_map_keys_to_array(__.property_bindings_map);
		}
		
		///@desc	Checks if a property has a binding (true) or not (false).
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Bool} has_property_bindings
		static property_has_binding = function(_property_name){
			return ds_map_exists(__.property_bindings_map, _property_name);
		}
		
		// ====================
		
		///@desc	Binds a property to a variable in a struct.
		///@param	{String} property_name
		///@param	{Struct} target_struct
		///@param	{String} variable_name
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_property_binding = function(_property_name, _inst_or_struct, _variable_name) {
			var _new_binding = new GekkoBinding(self, _property_name, _inst_or_struct, _variable_name);
			if property_has_binding(_property_name) {
				remove_property_binding(_property_name);
			}
			__.property_bindings_map[? _property_name] = _new_binding;
		
			return self;		
		}
			
		///@desc	Sets a function to run whenever a binding change.
		///@param	{String} property_name
		///@param	{Function} func
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_property_on_change = function(_property_name, _func) {
			variable_struct_set(self, "on_change_" + _property_name, method(self, _func));
			return self;
		}
			
		///@desc	Sets a function to run whenever a binding increase.
		///@param	{String} property_name
		///@param	{Function} func
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_property_on_increase = function(_property_name, _func) {
			variable_struct_set(self, "on_increase_" + _property_name, method(self, _func));
			return self;
		}
			
		///@desc	Sets a function to run whenever a binding decrease.
		///@param	{String} property_name
		///@param	{Function} func
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self		
		static set_property_on_decrease = function(_property_name, _func) {
			variable_struct_set(self, "on_decrease_" + _property_name, method(self, _func));
			return self;
		}
		
		// ====================
		
		///@desc	Removes the function to run whenever a binding change.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static remove_property_on_change = function(_property_name) {
			variable_struct_remove(self, "on_change_" + _property_name);
		}
			
		///@desc	Removes the function to run whenever a binding increase.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static remove_property_on_increase = function(_property_name) {
			variable_struct_remove(self, "on_increase_" + _property_name);
		}
			
		///@desc	Removes the function to run whenever a binding decrease.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static remove_property_on_decrease = function(_property_name) {
			variable_struct_remove(self, "on_decrease_" + _property_name);
		}
			
		///@desc	Removes a property binding from the component.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static remove_property_binding = function(_property_name) {
			// Remove this check later in place of propper type checking.
			if not is_string(_property_name) {
				throw __gekko_error("property_name is not of type String.");
			}
		
			if ds_map_exists(__.property_bindings_map, _property_name) {
				var _binding = __.property_bindings_map[? + _property_name].destroy();
				ds_map_delete(__.property_bindings_map, _property_name);
			}
			return self;
		}
			
		///@desc	Removes all property binding from the component.
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static remove_all_property_bindings = function() {
			var _names = get_property_bindings();
			var _len = array_length(_names);
			for(var _i = 0; _i < _len; _i++){
				remove_property_binding(_names[_i]);
			}
			return self;
		}
			
		#endregion
		
		#region Shaders ===================================
		
		///@desc	Sets a custom shader to draw the component with.
		///@param	{Asset.GMShader} shader
		///@param	{Struct[Array[String, Any]]} uniforms
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponent} self
		static shader_set_shader = function(_shader, _uniforms={}) {
			if (_shader == -1) {
				self.shader_reset_shader();
				return self;
			}
			__.is_using_shader = true;
			__.active_shader = _shader;
			self.shader_set_uniforms(_uniforms);
			
			return self;
		}
			
		///@desc	Sets uniforms for the components shader.
		///@param	{Struct[Array[String, Any]]} uniforms 
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponent} self	
		static shader_set_uniforms = function(_uniforms={}) {
			
			var _data = {};
			var _uniform_names = variable_struct_get_names(_uniforms);
			var _len = array_length(_uniform_names); var _uni_name;
			
			for(var _i = 0; _i < _len; _i++){
				_uni_name = _uniform_names[_i]; 
				_ref = is_numeric(_uni_name) ? _uni_name : shader_get_uniform(__.active_shader, _uni_name);
				variable_struct_set(_data, _ref, variable_struct_get(_uniforms, _uni_name));
			}
			
			__.shader_uniforms = _data;
			
			return self;
		}
			
		///@desc	Removes the custom shader from the component.
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponent} self	
		static shader_reset_shader = function() {
			__.is_using_shader = false;
			__.active_shader = -1;
			self.shader_set_uniforms();
			
		}
			
		///@desc	Gets the custom shader from the component.
		///@context GekkoComponentAbstract
		///@return	{Asset.GMShader} self		
		static get_shader = function() {
			return __.active_shader;
		}
			
		///@desc	Gets the uniforms for the components shader.
		///@context GekkoComponentAbstract
		///@return	{Struct} uniforms 	
		static get_shader_uniforms = function() {
			return __.shader_uniforms;
		}
			
		#endregion
		
		#region Custom Properties =========================
		
		///@desc	Creates a custom property to store values in.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static add_custom_property = function(_property_name) {
			if not __can_create_custom_property() { __gekko_throw_error("Can't create property of name: " + _property_name + " ") }
			__create_property_variables(_property_name);
			__.custom_property_map[? _property_name] = true;
			return self;
		}
			
		///@desc	Sets the value of a custom property.
		///@param	{String} property_name
		///@param	{Any} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_custom_property = function(_property_name, _val) {
			if is_custom_property(_property_name) {
				variable_struct_set(self.__, _property_name, _val);
				return self;
			} else {
				__gekko_throw_error("Trying to set non-existant custom-property: " + _property_name);
			}
		}
			
		///@desc	Gets the value of a custom property.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Any} value
		static get_custom_property = function(_property_name) {
			if is_custom_property(_property_name) {
				return variable_struct_get(self.__, _property_name);
			} else {
				__gekko_throw_error("Trying to get non-existant custom-property: " + _property_name);
			}
		}
			
		///@desc	Checks if a property exists in/on the component.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Bool} property_exists
		static property_exists = function(_property_name) {
			return variable_struct_exists(self.__, _property_name);
		}
			
		///@desc	Checks if a property is a custom property (true) or not (false).
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Bool} is_custom_property	
		static is_custom_property = function(_property_name){
			return ds_map_exists(self.__.custom_property_map, _property_name);
		}
	
		// TODO
		static remove_custom_property = function(_property_name) {}
		#endregion
		
		#region Animated properties =======================
		
		///@desc	Adds properties to the list of properties that should be animated.
		///@context GekkoComponentAbstract
		///@param	{Array[String]} property_name_array
		static add_animated_properties = function(_arr) {
			if variable_struct_exists(self.__, "animated_properties"){
				variable_struct_set(self.__, "animated_propertie", array_concat(self.__.animated_properties, _arr))
			} else {
				self.__.animated_properties = _arr;
			}
		}
			
		// ====================
		
		///@desc	Returns an array of the components animated properties.
		///@context GekkoComponentAbstract
		///@return	{Array[String]} property_name_array
		static get_animated_properties = function() {
			return __.animated_properties; // Could perhaps copy the array, don't know if it's passed by value or ref in GM rn.
		}	
			
		///@desc	Gets the animation style of a property.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{String} animation_style
		static get_property_animation_style = function(_name){
			if property_has_animation_style(_name){
				return __.property_animation_style[? _name];
			}
			return __.default_animation_style;
		}
			
		///@desc	Gets the GekkoSpring of a property.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoSpring} spring	
		static get_property_spring = function(_name) {
			if not ds_map_exists(self.__.property_spring_map, _name) {
				return __.default_spring;
			}
			return self.__.property_spring_map[? _name];
		}
			
		///@desc	Gets the target value of a property.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{any} target_value		
		static get_property_target = function(_name) {
			var _target_name = "target_" + _name;
			if variable_struct_exists(self.__, _target_name){
				return variable_struct_get(self.__, _target_name);
			}
		}
			
		///@desc	Gets the value of a property.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{any} value	
		static get_property_value = function(_name) {
			if variable_struct_exists(self.__, _name){
				return variable_struct_get(self.__, _name);
			}
		}
		
		///@desc	Gets the velocity of a property.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{any} velocity	
		static get_property_velocity = function(_name) {
			var _velocity_name = "velocity_" + _name;
			if variable_struct_exists(self.__, _name){
				return variable_struct_get(self.__, _velocity_name);
			}
		}
			
		///@desc	Gets LERP speed of a property.
		///@param	{String} property_name
		///@context GekkoComponentAbstract
		///@return	{Real} lerp		
		static get_property_lerp_speed = function(_name) {
			if property_has_animation_style(_name) {
				return __.property_lerp_speed[? _name];
			}
			return __.lerp_speed;
		}
		
		// ====================
		
		///@desc	Sets the target value of a property.
		///@param	{String} property_name
		///@param	{Any} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponent} self	
		static set_property_target = function(_name, _val) {
			var _target_name = "target_" + _name;
			variable_struct_set(self.__, _target_name, _val);
			return self;
		}
			
		///@desc	Sets the value of a property.
		///@param	{String} property_name
		///@param	{Any} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponent} self	
		static set_property_value = function(_name, _val) {
			var _method_name = "set_" + _name;
			if not variable_struct_exists(self, _method_name) {
				variable_struct_set(self.__, _name, _val);
			}
			var _set_method = variable_struct_get(self, _method_name);
			_set_method(_val);
			return self;
		}
			
		///@desc	Sets the velocity of a property.
		///@param	{String} property_name
		///@param	{Any} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponent} self	
		static set_property_velocity = function(_name, _val) {
			var _velocity_name = "velocity_" + _name;
			variable_struct_set(self.__, _velocity_name, _val);
			return self;
		}
			
		///@desc	Sets the animation style of a property.
		///@param	{String} property_name
		///@param	{Any} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponent} self	
		static set_property_animation_style = function(_name, _style) { 
			
			// Spring Animation
			if gekko_is_spring(_style){
				__.property_animation_style[? _name] = GEKKO_ANIMATION_STYLE.SPRING;
				__.property_spring_map[? _name] = _style;
			}
		
			// Lerp or Constant
			if is_numeric(_style) {
				__.property_lerp_speed[? _name] = min(1, _style);
				if __.property_lerp_speed[? _name] == 1 {
					__.property_animation_style[? _name] = GEKKO_ANIMATION_STYLE.INSTANT;
				} else {
					__.property_animation_style[? _name] = GEKKO_ANIMATION_STYLE.LERP;
				}
			}

			return self; 
		}
			
		///@desc	Sets the default animation style for the component.
		///@param	{Any} animation_style
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponent} self	
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
		
		// ====================
		
		///@desc	Removes the custom animation style from a property.
		///@context GekkoComponentAbstract
		///@param	{String} property_name
		static remove_property_animation_style = function(_name) {
			if property_has_animation_style(_name){
				ds_map_delete(__.property_animation_style, _name);
				if ds_map_exists(__.property_lerp_speed, _name) {
					ds_map_delete(__.property_lerp_speed, _name);
				}
				if ds_map_exists(__.property_spring_map, _name) {
					ds_map_delete(__.property_spring_map, _name);
				}	
			}
		}
			
		///@desc	Checks if a property has a custom animation style.
		///@param	{String} property_name 
		///@context GekkoComponentAbstract
		///@return	{Bool} has_animation_style
		static property_has_animation_style = function(_name) {
			return ds_map_exists(__.property_animation_style, _name);
		}
		
		// ====================
		
		///@ignore
		///@desc	INTERNAL: Updates an animated property.
		///@context GekkoComponentAbstract
		///@param	{String} property_name 
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
			
		///@ignore
		///@desc	INTERNAL: Updates all animated properties.
		static update_animated_properties = function() {
			static _vars = get_animated_properties();
			var _len = array_length(_vars);
			for(var _i = 0; _i < _len; _i++){
				update_animated_property(_vars[_i])
			}
		}
			
		#endregion
		
		#region General ===================================
		
		///@desc	Checks if the component is visible (true) or not (false).
		///@context GekkoComponentAbstract
		///@return	{Bool} is_visible
		static is_visible = function() {
			var _vis = __.visible;
			if has_parent() {
				_vis = _vis && get_parent().is_visible();
			}
			return _vis;
		}
			
		///@desc	Checks if the component offset is absolute (true) or not (false).
		///@context GekkoComponentAbstract
		///@return	{Bool} is_visible	
		static is_offset_absolute = function() {
			return __.offset_absolute;
		}
		
		///@desc	Checks if the component has a parent (true) or not (false).
		///@context GekkoComponentAbstract
		///@return	{Bool} is_visible	
		static has_parent = function() {
			return __.parent != noone;
		}
		
		///@desc	Removes the parent from the component.
		///@context GekkoComponentAbstract
		static remove_parent = function() {
			if has_parent() { __.parent.remove_child(self); }
			__.parent = noone;
		}
		
		///@desc	Checks if a position is inside the components bounding box (true) or not (false).
		///@param	{Real}	x
		///@param	{Real}	y
		///@context GekkoComponentAbstract
		///@return	{Bool} is_visible
		static is_position_inside = function(_x, _y) {
			var _s = gekko_get_scale();
			return (_x >= get_bbox_left() *_s && _x <= get_bbox_right()*_s && _y >= get_bbox_top()*_s && _y <= get_bbox_bottom()*_s );
		}
		
		///@desc	Checks if the mouse is hovering over the components bounding box (true) or not (false).
		///@context GekkoComponentAbstract
		///@return	{Bool} is_hover
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
		
		///@desc	Checks if the component is clickable (true) or not (false).
		///@context GekkoComponentAbstract
		///@return	{Bool} is_clickable
		static is_clickable = function() {
			return __.clickable;
		}
		
		///@desc	Checks if the component is tapable (true) or not (false).
		///@context GekkoComponentAbstract
		///@return	{Bool} is_tapable
		static is_tapable = function() {
			return __.tapable;
		}
		
		///@desc	Checks if the component is anchored (true) or not (false).
		///@context GekkoComponentAbstract
		///@return	{Bool} is_anchored
		static is_anchored = function() {
			return __.anchor_point != GEKKO_ANCHOR.NONE;
		}	
		
		///@desc	Adds a child to the component.
		///@context GekkoComponentAbstract
		///@param	{Struct.GekkoComponentAbstract}	gekko_component
		static add_child = function(_child) {
			if _child.has_parent() {
				_child.remove_parent();
				_child.__.parent = self;	
			}
			array_push(__.children, _child);
			//update();
			//update_all_children();
		}	
			
		///@desc	Removes child from the component.
		///@context GekkoComponentAbstract
		///@param	{Struct.GekkoComponentAbstract}	gekko_component	
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
			
		///@desc	Checks if the components parent exists (true) or not (false).
		///@context GekkoComponentAbstract
		///@return	{Bool} is_anchored
		static parent_exists = function() {
			return gekko_component_exists(__.parent);
		}
			
		///@desc	Destroys the component and removes it from family trees.
		///@context GekkoComponentAbstract
		static destroy = function() {
			__gekko_add_to_destroy_array(self);
		}
		
		static destroy_hirarchy = function() {
			self.__delete_hirarchy();
		}
			
		///@desc	Runs a function with all children.
		///@context GekkoComponentAbstract
		///@param	{Function}	func	
		static with_children = function(_func) {
			var _a = __.children;
			var _len = array_length(_a);
			for(var _i = 0; _i < _len; _i++) {
				with(__.children[_i]){
					_func();
				}
			}
		}
		
		///@ignore
		///@context GekkoComponentAbstract
		///@desc	INTERNAL: Runs at end of step and destroys the compoenent.
		static __destroy = function() {
			remove_all_property_bindings();
			remove_parent();
			__remove_all_children();
			__gekko_tracking_remove_component(get_id());
			__tear_down_private_struct();	
		}
		
		
		static __remove_all_children = function() {
			var _len = array_length(__.children);
			repeat(_len) {
				__.children[0].remove_parent();
			}
		}
		
		
		static __delete_hirarchy = function () {
			var _len = array_length(__.children);
			var _i = 0;
			repeat(_len) {
				__.children[_i].__delete_hirarchy();
				_i++;
			}
			self.destroy();
		
		}
		
		
		static delete_hirarchy = function() {
			__delete_hirarchy();
		}
			
		#endregion
		
		#region Labels ====================================
			static label_add = function(_label) {
				if not has_label(_label) {
					__gekko_track_component_label(self, _label);
					ds_map_add(__.label_map, _label, true);
				}
				return self;
			}
			
			static label_remove = function(_label) {
				if has_label(_label) {
					__gekko_remove_component_label(self, _label);
					ds_map_delete(__.label_map, _label);
				}
				return self;			
			}
			
			static has_label = function(_label){
				return ds_map_exists(__.label_map, _label);
			}
		#endregion
		
		#region Setters ===================================
		
		///@desc	Sets the draw visability of the component.
		///@param	{bool} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_visible = function(_bool) {
			__.visible = _bool;
			return self;
		}
			
		///@desc	Sets the x position of the component.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_x = function(_val) {
			__.x = _val;
			return self;
		}
			
		///@desc	Sets the y position of the component.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_y = function(_val) {
			__.y = _val;
			return self;
		}
			
		///@desc	Sets the draw color of the component.
		///@param	{Constant.Colour} draw_color
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_color = function(_col) {
			__.color = _col;
			return self;
		}
			
		///@desc	Sets the scale of the component (default = 1).
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
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
			
		///@desc	Sets the target scale of the component.
		///@param	{Real} target_value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_target_scale = function(_val) {
			__.target_scale = _val;
			return self;
		}
			
		///@desc	Sets the depth of the component.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_depth = function(_val) {
			var _m = __gekko_get_manager();
			__.component_depth = _val;
			__gekko_depth_array_update_pos(self);
			return self;
		}
			
		///@desc	Sets the parent of the component.
		///@param	{Struct.GekkoComponentAbstract} gekko_component
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_parent = function(_parent) {
			if has_parent() { remove_parent(); }
			__.parent = _parent;
			array_push(__.parent.__.children, self);
			return self;
		}
	
		///@desc	Setting the offset as absolute will always make the offset the same independant of the current GUI scale.
		///@param	{bool} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_offset_absolute = function(_bool) {
			__.offset_absolute = _bool;
			return self;
		}
	
		///@desc	Sets the Anchor point with the GEKKO_ANCHOR enum as argument.
		///@param	{Real} anchor_point
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_anchor_point = function(_anchor_point) {
			__.anchor_point = _anchor_point;
			return self;
		}	
		
		///@desc	Sets the anchor offset in x axis.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_anchor_offset_x = function(_val) {
			__.anchor_offset_x = _val;
			return self;
		}
		
		///@desc	Sets the anchor offset in y axis.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_anchor_offset_y = function(_val) {
			__.anchor_offset_y = _val;
			return self;
		}
		
		///@desc	Sets the target anchor offset in x axis.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_target_anchor_offset_x = function (_val) {
			__.target_anchor_offset_x = _val;
			return self;
		}
		
		///@desc	Sets the target anchor offset in y axis.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_target_anchor_offset_y = function (_val) {
			__.target_anchor_offset_y = _val;
			return self;
		}
		
		///@desc	Sets the velocity of the anchor offset in x axis.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_velocity_anchor_offset_x = function (_val) {
			__.velocity_anchor_offset_x = _val;
			return self;
		}
		
		///@desc	Sets the velocity of the anchor offset in y axis.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_velocity_anchor_offset_y = function (_val) {
			__.velocity_anchor_offset_y = _val;
			return self;
		}
		
		///@desc	Sets the component alignment of the component.
		///@param	{Real} component_alignment passed as a GEKKO_COMPONENT_ALIGNMENT enum.
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_component_alignment = function(_alignment) {
			__.component_alignment = _alignment;
			return self;
		}
			
		///@desc	Sets the component as clickable (true) or not (false) (default is false).
		///@param	{bool} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_clickable = function(_bool) {
			__.clickable = _bool;
			return self;
		}
			
		///@desc	Sets the component as tapable (true) or not (false) (default is false).
		///@param	{bool} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_tapable = function(_bool) {
			__.tapable = _bool;
			return self;
		}
			
		///@desc	Sets the step function of the component (run each step).
		///@param	{Function} func
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self		
		static set_step = function(_func) {
			step = method(self, _func);
			return self;
		}
			
		///@desc	Sets the on_click event function of the component (run when component is clicked).
		///@param	{Function} func
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_on_click = function(_func) {
			on_click = method(self, _func);
			return self;
		}
			
		///@desc	Sets the on_tap event function of the component (run when component is clicked).
		///@param	{Function} func
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self		
		static set_on_tap = function(_func) {
			on_tap = method(self, _func);
			return self;
		}
			
		///@desc	Sets default component animation style to LERP and sets it to the provided value.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self	
		static set_lerp_speed = function(_lerpspd){
			set_default_animation_style(_lerpspd)
			return self;
		}
			
		///@desc	Sets the ID of the component.
		///@param	{Real} value
		///@context GekkoComponentAbstract
		///@return	{Struct.GekkoComponentAbstract} self
		static set_id = function(_id) {
			__.component_id = _id;
			return self;
		}
			
		#endregion
			
		#region Getters ===================================
		
		///@desc Gets the current draw color of the component.
		///@context GekkoComponentAbstract
		///@return {Constant.Color}	current draw color.
		static get_color = function() {
			return __.color;
		}
		
		///@desc Gets the current scale of the component.
		///@context GekkoComponentAbstract
		///@return {Real}  scale of the component.
		static get_scale = function() {
			return __.scale;
		}
		
		///@desc Gets the the hirarchal total scale of all ansestors.
		///@context GekkoComponentAbstract
		///@return {Real}  scale of the parent component.
		static get_parent_scale = function() {
			if has_parent() {
				return __.parent.__.scale * __.parent.get_parent_scale();
			}
			return 1;
		} 
		
		///@desc Gets the current draw depth of the component.
		///@context GekkoComponentAbstract
		///@return {Real}  depth of the component.
		static get_depth = function() {
			return __.component_depth;
		}
		
		///@desc Gets the current draw depth of the component.
		///@context GekkoComponentAbstract
		///@return {Real}  Enum value of type GEKKO_COMPONENT_ALIGNMENT.
		static get_component_alignment = function() {
			return __.component_alignment;
		}
		
		///@desc Gets the id of the component.
		///@context GekkoComponentAbstract
		///@return {Real}  id of the component.
		static get_id = function() {
			return __.component_id;
		}
		
		///@desc Gets the target x position of the component.
		///@context GekkoComponentAbstract
		///@return {Real} target x value.
		static get_target_x = function() {
			return __.target_x;
		}
		
		///@desc Gets the target y position of the component.
		///@context GekkoComponentAbstract
		///@return {Real} target y value.
		static get_target_y = function() {
			return __.target_y;
		}
			
		///@desc Gets the target scale of the component.
		///@context GekkoComponentAbstract
		///@return {Real} target scale of the component.
		static get_target_scale = function() {
			return __.target_scale;
		}
		
		///@desc Gets the x position of the component.
		///@context GekkoComponentAbstract
		///@return {Real}  x value of the component.
		static get_x = function() {
			return __.x;
		}
			
		///@desc Gets the y position of the component.
		///@context GekkoComponentAbstract
		///@return {Real} y value of the component.
		static get_y = function() {
			return __.y;
		}	
		
		///@desc Gets the draw x position of the component.
		///@context GekkoComponentAbstract
		///@return {Real}  draw x value.
		static get_draw_x = function() {
			return get_x() / get_scale() / get_parent_scale();
		}
		
		///@desc Gets the draw y position of the component.
		///@context GekkoComponentAbstract
		///@return {Real}  draw y value.
		static get_draw_y = function() {
			return get_y() / get_scale() / get_parent_scale();
		}
			
		///@desc Gets the x offset from the origin, used by sprites for rendering.
		///@context GekkoComponentAbstract
		///@return {Real} x origin offset.
		static get_origin_offset_x = function() {
			return 0;
		}
			
		///@desc Gets the y offset from the origin, used by sprites for rendering.
		///@context GekkoComponentAbstract
		///@return {Real} y origin offset.
		static get_origin_offset_y = function() {
			return 0;
		}
		
		///@desc Gets the width of the component.
		///@context GekkoComponentAbstract
		///@return {Real} width of the component.
		static get_width = function() {
			return get_true_width() * get_scale() * get_parent_scale();
		}
		
		///@desc Gets the height of the component.
		///@context GekkoComponentAbstract
		///@return {Real} height of the component.
		static get_height = function() {
			return get_true_height() * get_scale() * get_parent_scale();
		}
			
		///@desc Gets the base width of the component without scale applied.
		///@context GekkoComponentAbstract
		///@return {Real} width of the component.
		static get_true_width = function() {
			return 0;
		}
		
		///@desc Gets the base height of the component without scale applied.
		///@context GekkoComponentAbstract
		///@return {Real} width of the component.
		static get_true_height = function() {
			return 0;
		}
		
		///@desc Gets the parent id of the component.
		///@context GekkoComponentAbstract
		///@return {Real} parent id.
		static get_parent_id = function() {
			if parent_exists(){
				return __.parent.get_id();
			}
			return -1 // Parent does not exist.
		}	
			
		///@desc Gets the parent component instance of the component.
		///@context GekkoComponentAbstract
		///@return {Struct.GekkoComponentAbstract} parent component instance.
		static get_parent = function() {
			return __.parent;
		}
		
		///@desc Gets the anchor offset in the x axis of the component.
		///@context GekkoComponentAbstract
		///@return {Real} x offset from the anchor point.
		static get_component_anchor_offset_x = function() {
			return 0;
		}
		
		///@desc Gets the anchor offset in the y axis of the component.
		///@context GekkoComponentAbstract
		///@return {Real} y offset from the anchor point. 
		static get_component_anchor_offset_y = function() {
			return 0;
		}		
			
		///@desc Gets the anchor offset in the x acis of the component.	
		///@context GekkoComponentAbstract
		///@return {Real} x value of the anchor point.
		static get_anchor_offset_x = function() {
			if is_offset_absolute() { return __.anchor_offset_x / gekko_get_scale(); } 
			return __.anchor_offset_x;
		}	
		
		///@desc Gets the anchor offset in the y acis of the component.	
		///@context GekkoComponentAbstract
		///@return {Real} y value of the anchor point.
		static get_anchor_offset_y = function() {
			if is_offset_absolute() { return __.anchor_offset_y / gekko_get_scale(); } 
			return __.anchor_offset_y;
		}	
		
		///@desc Gets the x anchor point of the component.	
		///@context GekkoComponentAbstract
		///@return {Real} x value of the anchor point.
		static get_anchor_point_x = function() {
			if parent_exists() {
				return __.parent.get_child_anchor_x(self);
			} else {
				return gekko_get_global_anchor_point_x(__.anchor_point);
			}
		}
			
		///@desc Gets the y anchor point of the component.	
		///@context GekkoComponentAbstract
		///@return {Real} y value of the anchor point.
		static get_anchor_point_y = function() {
			if parent_exists() {
				return __.parent.get_child_anchor_y(self);
			} else {
				return gekko_get_global_anchor_point_y(__.anchor_point);
			}
		}	
			
		///@desc Called and used by children to fetch calculate their x anchor point.
		///@param {Struct.GekkoComponentAbstract}	component The child to calculate the x anchor point for.
		///@context GekkoComponentAbstract
		///@return {Real}  x value of the anchor point.
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
			
		///@desc Called and used by children to fetch calculate their y anchor point.
		///@param {Struct.GekkoComponentAbstract}	component The child to calculate the y anchor point for.
		///@context GekkoComponentAbstract
		///@return {Real} y value of the anchor point.
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
			
		///@desc Gets the x coordinate of the left side of the bounding box of the component.
		///@context GekkoComponentAbstract
		///@return {Real} x value of the bbox left.
		static get_bbox_left = function() {
			return get_x();
		}
		
		///@desc Gets the x coordinate of the right side of the bounding box of the component.
		///@context GekkoComponentAbstract
		///@return {Real} x value of the bbox right.
		static get_bbox_right = function() {
			return get_bbox_left() + get_width();
		}	
		
		///@desc Gets the y coordinate of the top side of the bounding box of the component.
		///@context GekkoComponentAbstract
		///@return {Real} y value of the bbox top.
		static get_bbox_top = function() {
			return get_y();
		}
			
		///@desc Gets the y coordinate of the bottom side of the bounding box of the component.	
		///@context GekkoComponentAbstract
		///@return {Real} y value of the bbox bottom.
		static get_bbox_bottom = function() {
			return get_y() + get_height();
		}
			
		///@desc Gets the calculated scale of the component multiplied by all ansestors scales.
		///@context GekkoComponentAbstract
		///@return {Real} Final total scale.
		static get_total_scale = function() {
			return get_scale() * get_parent_scale();
		}	
			
		#endregion
		
		#region Event methods =============================
		
		///@desc Function linked to the component that run each step.
		///@context GekkoComponentAbstract
		step = function() {
			return
		}
		
		///@desc Function that run when component is clicked.
		///@context GekkoComponentAbstract
		on_click = function() {
			return
		}
		
		///@desc Function that run when component is tapped.
		///@context GekkoComponentAbstract
		on_tap = function() {
			return
		}
			
		#endregion
		
}
