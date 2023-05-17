// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GekkoBinding(_owner, _property_name, _target, _variable_name) constructor {
	
	#region Private ============================================
	#region Initial Set up
	static __id_itterator = 0;
	__ = {}; with(__){
		owner			= _owner;
		property_name	= _property_name;
		target_inst		= _target;
		target_variable = _variable_name;
		binding_id		= __id_itterator;
	}
	__id_itterator += 1;
	
	// Run some additional methods for initial setup
	__initial_setup();
	#endregion
	#region Internal Methods
	
	static __initial_setup = function() {
		
		__update_types();
		
		var _val = 0;
		if __can_fetch_variable() {
			_val = __fetch_variable();
		}
		__.previous_value = _val;
		__.value = _val;
	}
	static __update_types = function() {
		__.owner_type	= __get_type(true);
		__.target_type	= __get_type(false);
	}
	static __get_type = function(_get_owner = true) {
		var _si = _get_owner ? get_owner() : get_target();
		var _property_name = _get_owner ? get_property_name() : get_target_variable_name();
		
		if gekko_is_component(_si){
			var _valid_struct	= is_struct(_si) && variable_struct_exists(_si.__, _property_name);
		} else {
			var _valid_struct	= is_struct(_si) && variable_struct_exists(_si, _property_name);
		}
		var _valid_inst		= false && variable_instance_exists(_si, _property_name); 

	
		if _valid_struct { return "struct"; } 
		elif _valid_inst { return "inst";   } 
		else			 { return noone;    }
	}
	
	static __variable_exists = function(_context, _variable_name){
		if gekko_is_component(_context) {
			return variable_struct_exists(_context.__, _variable_name);
		} elif is_struct(_context) {
			return variable_struct_exists(_context, _variable_name);
		} else {
			return variable_instance_exists(_context, _variable_name);
		}
	}
	
	static __can_fetch_variable = function() {
		var _si = get_target();
		var _property_name = get_target_variable_name();
		var _valid_struct	= is_struct(_si) && __variable_exists(_si, _property_name);
		var _valid_inst		= false && __variable_exists(_si, _property_name); 

	
		if _valid_struct && __.target_type == "struct" { return true; } 
		elif _valid_inst && __.target_type == "inst"   { return true; } 
		else { return false; }
	}
	static __fetch_variable = function() {
		if __.target_type == "struct" {
			var _var = variable_struct_get(get_target(), get_target_variable_name());
			return _var;
		} else {
			var _var = variable_instance_get(get_target(), get_target_variable_name());
			return _var;
		}
	}
	
	static __can_set_property = function() {
		var _si = get_owner();
		var _property_name = get_property_name();
		
		var _valid_struct	= is_struct(_si);
		var _valid_inst		= false;
	
		if _valid_struct && __.owner_type == "struct" { return true; } 
		elif _valid_inst && __.owner_type == "inst"   { return true; } 
		else { return false; }
	}
	static __owner_exists = function() {
		var _o = get_owner();
		return (false or is_struct(_o));
	}
	static __owner_has_set_method = function() {
		if __.owner_type == "struct" {
			var _set_name = "set_" + get_property_name();
			return variable_struct_exists(get_owner(), _set_name) && is_method(variable_struct_get(get_owner(), _set_name));
		} else {
			return variable_instance_exists(get_owner(), "set_" + get_property_name()) && is_method(variable_instance_get(get_owner(), _set_name));;
		}
	}
	static __owner_has_method = function(_method_name) {
		if not __owner_exists() {return false}
		if __.owner_type == "struct" {
			return variable_struct_exists(get_owner(), _method_name) && is_method(variable_struct_get(get_owner(), _method_name));
		} else {
			return variable_instance_exists(get_owner(), _method_name) && is_method(variable_instance_get(get_owner(), _method_name));
		}
	}
	static __owner_get_method = function(_method_name) {
		if __owner_has_method(_method_name){
			if __.owner_type == "struct" {
				return variable_struct_get(get_owner(), _method_name);
			} else {
				return variable_instance_get(get_owner(), _method_name);
			}
		}
	}
	static __owner_has_on_change_method = function() {
		return __owner_has_method("on_change_" + get_property_name());
	}
	static __owner_has_on_increase_method = function() {
		return __owner_has_method("on_increase_" + get_property_name());
	}
	static __owner_has_on_decrease_method = function() {
		return __owner_has_method("on_decrease_" + get_property_name());
	}
	static __owner_call_method = function(_method_name){
		if __owner_has_method(_method_name) {
			var _method = method(get_owner(), __owner_get_method(_method_name));
			_method();
		}
	}
	
	static __call_on_change = function() {
		var _method_name = "on_change_" + get_property_name();
		__owner_call_method(_method_name, get_property_name());
	}
	static __call_on_increase = function() {
		var _method_name = "on_increase_" + get_property_name();
		__owner_call_method(_method_name, get_property_name());
	}
	static __call_on_decrease = function() {
		var _method_name = "on_decrease_" + get_property_name();
		__owner_call_method(_method_name);
	}
	
	static __set_previous_value = function(_val) {
		__.previous_value = _val;
	}
	static __set_value = function(_val) {
		__.value = _val;
	}
	static __update_owner_value = function() {

		if __owner_exists() {
			var _o = get_owner();
			var _new_val = __fetch_variable();
			// Owner has a dedicated set method.
			if __owner_has_set_method() {
				var _method = method(get_owner(), __owner_get_method("set_" + get_property_name()));
				_method(get_value());

			// Is Custom Property
			} else if get_owner().is_custom_property(get_property_name()) {
				get_owner().set_custom_property(get_property_name(), _new_val);	
			
			// Is weird Shenanigans
			}				
		}
	}

	
	#endregion ============================================
	#endregion
	
	static update = function() {
		
		if not __can_fetch_variable() or not __can_set_property() { return }
		
		var _current_value = get_value();
		__set_previous_value(_current_value);
		var _new_value = __fetch_variable();
		
		// Update the Owner values
		if (_new_value != _current_value) {
			__update_owner_value();
			
			__call_on_change(); // Call the on_change callback.
			
			var _curr = _new_value;
			var _prev = _current_value;
			if is_numeric(_prev) && is_numeric(_curr){
				if _curr > _prev {
					__call_on_increase();
				} elif _curr < _prev {
					__call_on_decrease();
				}
			}
		}
		
		__set_value(_new_value);
	}
	static get_owner = function() {
		return __.owner;
	}	
	static get_property_name = function() {
		return __.property_name;
	}
	static get_target = function() {
		return __.target_inst;
	}
	static get_target_variable_name = function() {
		return __.target_variable;
	}
	static destroy = function() {
		__gekko_remove_binding(self);
	}
	static get_value = function() {
		if variable_struct_exists(__, "value") {
			return __.value;
		} else {
			return undefined;
		}
	}
	static get_previous_value = function() {
		if variable_struct_exists(__, "previous_value") {
			return __.previous_value;
		} else {
			return undefined;
		}
	}
	static get_id = function() {
		return __.binding_id;
	}
	
	// Track Binding for automatic Binding update through gekko_update();
	
	//show_message(string(_owner) + " " + _property_name + " " + string(_target) + " " + _variable_name);
	
	__gekko_track_binding(self);

}

//var _healthbar = gekko_create_healthbar()
//.property_binding_add("width", o_game, "health")
//.property_set_on_change()
//.property_set_on_increase()
//.property_set_on_decrease()