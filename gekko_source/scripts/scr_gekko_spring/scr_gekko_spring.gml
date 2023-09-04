
/*=========================================================

Gekko Util : Spring

GekkoSprings are used to animate component properties
users will need to provide an existing spring instance
when setting the animation style of a component or a
specific property to Spring. 

If you wish to not create a new spring you can use
the macro GEKKO_SPRING_DEFAULT to use the default
spring. 

Note: Changing the properties of a spring will 
alter the behaviour of any property that is animated 
using that spring.

=========================================================*/

function GekkoSpring() constructor {
	
	#region Private ===========================================================
	__gekko_create_private_struct(self); with(__){
		type		= GEKKO_TYPE.UTIL_SPRING;
		grav		= 0;
		mass		= 50;
		k			= 8;	// Spring Constant
		damping		= 12;
		
		// mass 50, k 5, damp 5.
	}
	
	///@ignore
	///@desc Updates the GekkoSpring
	static update = function(_component, _property_name) {
		
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
	
	#endregion
	
	// Public =================================================================
	
		#region General =======================================
	
		///@desc Takes a GekkoSpring as input and copies it's property values into the GekkoSpring invoking
		/// the method.
		///@context GekkoSpring
		static clone_spring = function(_spring) {
			if gekko_is_spring(_spring){
				__.grav		= _spring.__.grav;
				__.mass		= _spring.__.mass;
				__.k		= _spring.__.k;
				__.damping	= _spring.__.damping;
			}	
		}
		
		#endregion
	
		#region Getters =======================================
	
		///@desc gets the gravity of the spring.
		///@context GekkoSpring
		///@return {Real} gravity
		static get_grav = function() {
			return __.grav;
		}
		
		///@desc gets the mass of the spring.
		///@context GekkoSpring
		///@return {Real} mass
		static get_mass = function() {
			return __.mass;
		}
		
		///@desc gets the target value of the spring.
		///@context GekkoSpring
		///@return {Real} target_value
		static get_target_val = function() {
			return __.target_val;
		}
	
		///@desc gets the current value of the spring.
		///@context GekkoSpring
		///@return {Real} value
		static get_val = function() {
			return __.val;
		}
		
		///@desc gets the velocity of the spring.
		///@context GekkoSpring
		///@return {Real} velocity
		static get_velocity = function() {
			return __.velocity;
		}
		
		///@desc gets spring constant of the spring.
		///@context GekkoSpring
		///@return {Real} k
		static get_k = function() {
			return __.k;
		}
		
		///@desc gets damping factor of the spring.
		///@context GekkoSpring
		///@return {Real} damping_factor
		static get_damping = function() {
			return __.damping;
		}
	
		#endregion
	
		#region Setters =======================================
	
		///@desc Sets the gravity of the spring.
		///@param {Real} gravity
		///@context GekkoSpring
		///@return {Struct.GekkoSpring} self
		static set_grav = function(_val) {
			if is_numeric(_val) {
				__.grav = _val;
			}
			return self;
		}
		
		///@desc Sets the mass of the spring.
		///@param {Real} mass
		///@context GekkoSpring
		///@return {Struct.GekkoSpring} self
		static set_mass = function(_val) {
			if is_numeric(_val) { __.mass = _val; }
			return self;
		}
	
		///@desc Sets the target value of the spring.
		///@param {Real} target_value
		///@context GekkoSpring
		///@return {Struct.GekkoSpring} self
		static set_target_val = function(_val) {
			if is_numeric(_val) { __.target_val = _val; }
			return self;
		}
	
		///@desc Sets the value of the spring.
		///@param {Real} value
		///@context GekkoSpring
		///@return {Struct.GekkoSpring} self
		static set_val = function(_val) {
			if is_numeric(_val) { __.val = _val; }
			return self;
		}
		
		///@desc Sets the velocity of the spring.
		///@param {Real} velocity
		///@context GekkoSpring
		///@return {Struct.GekkoSpring} self
		static set_velocity = function(_val) {
			if is_numeric(_val) { __.velocity = _val; }
			return self;
		}
	
		///@desc Sets the spring constant of the spring.
		///@param {Real} k
		///@context GekkoSpring
		///@return {Struct.GekkoSpring} self
		static set_k = function(_val) {
			if is_numeric(_val) { __.k = _val; }
			return self;
		}
		
		///@desc Sets the damping factor of the spring.
		///@param {Real} damping
		///@context GekkoSpring
		///@return {Struct.GekkoSpring} self
		static set_damping = function(_val) {
			if is_numeric(_val) { __.damping = _val; }
			return self;
		}	
		
		#endregion
		
	#endregion
}

