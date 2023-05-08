// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GekkoSpring() constructor {
	
	// Private ============================================
	__gekko_create_private_struct(self); with(__){
		type		= GEKKO_TYPE.UTIL_SPRING;
		grav		= 0;
		mass		= 50;
		k			= 8;	// Spring Constant
		damping		= 12;
		
		// mass 50, k 5, damp 5.
	}
	
	// Public =============================================
	static update = function(_component, _property_name){
		
		var _val		= _component.get_property_value(_property_name);
		var _target_val	= _component.get_property_target(_property_name);
		var _velocity	= _component.get_property_velocity(_property_name);
		
		if _val == _target_val && _velocity == 0 { return } // Insta Break
		
		// Calculate Forces
		var _time_step = 0.2 * gekko_get_time_scale();
		var _spring_force	= -__.k * (_val - _target_val);
		var _damping_force	= __.damping * _velocity;
		var _force			= _spring_force + (__.mass * __.grav) - _damping_force;
		var _acceleration	= _force / __.mass;
		
		if gekko_is_safe_springs_enabled() {
			while abs(_velocity + _acceleration) > abs((_val - _target_val)* 0.999) {
				_acceleration *= 0.95;
				_velocity *= 0.999
			}
		}
		
		// Update Values
		_component.set_property_velocity(_property_name, _velocity + _acceleration * _time_step); 
		_component.set_property_value(_property_name, _val + _velocity * _time_step);
	}
	static clone_spring = function(_spring) {
		if gekko_is_spring(_spring){
			__.grav		= _spring.__.grav;
			__.mass		= _spring.__.mass;
			__.k		= _spring.__.k;
			__.damping	= _spring.__.damping;
		}	
	}
	
	// Getters
	static get_grav = function() {
		return __.grav;
	}
	static get_mass = function() {
		return __.mass;
	}
	static get_target_val = function() {
		return __.target_val;
	}
	static get_val = function() {
		return __.val;
	}
	static get_velocity = function() {
		return __.velocity;
	}
	static get_k = function() {
		return __.k;
	}
	static get_damping = function() {
		return __.damping;
	}
	
	// Setters
	static set_grav = function(_val) {
		if is_numeric(_val) {
			__.grav = _val;
		}
		return self;
	}
	static set_mass = function(_val) {
		if is_numeric(_val) { __.mass = _val; }
		return self;
	}
	static set_target_val = function(_val) {
		if is_numeric(_val) { __.target_val = _val; }
		return self;
	}
	static set_val = function(_val) {
		if is_numeric(_val) { __.val = _val; }
		return self;
	}
	static set_velocity = function(_val) {
		if is_numeric(_val) { __.velocity = _val; }
		return self;
	}
	static set_k = function(_val) {
		if is_numeric(_val) { __.k = _val; }
		return self;
	}
	static set_damping = function(_val) {
		if is_numeric(_val) { __.damping = _val; }
		return self;
	}	
}

 