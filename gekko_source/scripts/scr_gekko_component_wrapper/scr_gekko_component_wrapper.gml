/*=========================================================

Gekko Component : Wrapper

This is a component that wraps around of a group of
components. It simply wraps its bounding-box to contain
all of it's sub-components.

=========================================================*/

function GekkoComponentWrapper(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) : GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private =====================================================================
		__gekko_create_private_struct(self); with(__){
			wrapped_components = [];
		}
		
		// Parent Method Overrides
		static get_width = function(){
			return (get_bbox_right() - get_bbox_left());
		}
		static get_height = function(){
			return (get_bbox_bottom() - get_bbox_top());
		}	
		static get_bbox_left = function(){
			var _len = array_length(__.wrapped_components);
			if _len == 0 { return x };
		
			var _val = 999999999999999999999;
			for(var _i = 0; _i < _len; _i++){
				_val = min(_val, __.wrapped_components[_i].get_bbox_left());
			}
			return _val
		}
		static get_bbox_right = function(){
			var _len = array_length(__.wrapped_components);
			if _len == 0 { return x };
		
			var _val = -999999999999999999999;
			for(var _i = 0; _i < _len; _i++){
				_val = max(_val, __.wrapped_components[_i].get_bbox_right());
			}
			return _val
		}
		static get_bbox_top = function(){
			var _len = array_length(__.wrapped_components);
			if _len == 0 { return x };
		
			var _val = 999999999999999999999;
			for(var _i = 0; _i < _len; _i++){
				_val = min(_val, __.wrapped_components[_i].get_bbox_top());
			}
			return _val
		}
		static get_bbox_bottom = function(){
			var _len = array_length(__.wrapped_components);
			if _len == 0 { return x };
		
			var _val = -999999999999999999999;
			for(var _i = 0; _i < _len; _i++){
				_val = max(_val, __.wrapped_components[_i].get_bbox_bottom());
			}
			return _val
		}
		static update_target_x = function(){
			__.target_x = get_bbox_left() + (get_width() / 2);
		}
		static update_target_y = function(){
			__.target_y = get_bbox_top() + (get_height() / 2);
		}
	#endregion

	// Public ===========================================================================
		
		#region General ===================================
		
		///@desc Adds a component to the wrapper
		///@context GekkoComponentWrapper
		///@return {Struct.GekkoComponentWrapper} self
		static add_component = function(_component_or_id){
			var _c = gekko_get_component(_component_or_id);
			array_push(__.wrapped_components, _c);
			return self
		}
			
		///@desc Removes a component to the wrapper
		///@param {Struct.GekkoComponent | Real} component_or_id 
		///@context GekkoComponentWrapper
		///@return {Struct.GekkoComponentWrapper} self
		static remove_component = function(_component_or_id){
			var _id		= gekko_component_get_id(_component_or_id);
			var _len	= array_length(__.wrapped_components);
			for(var _i = 0; _i < _len; _i++) {
				if wrapped_components[_i].get_id() == _id {
					array_delete(wrapped_components, _i, 1);
					return self;
				}
			}
			return self;
		}
			
		#endregion
		
}
