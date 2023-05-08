


function GekkoComponentNineSlice(_sprite_index, _image_index, _anchor_point, _anchor_offset_x, _anchor_offset_y, _parent) : GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private ===========================================================
		__gekko_create_private_struct(self); with(__) {
			sprite = _sprite_index;
			image_index = _image_index;
	
			slice_width = sprite_get_width(sprite);
			slice_height = sprite_get_height(sprite);
	
			target_slice_width = slice_width;
			target_slice_height = slice_height;
			velocity_slice_width = 0;
			velocity_slice_height = 0;
		}
		add_animated_properties(["slice_width", "slice_height"]);
		
		#region Parent Method Overrides
		static get_true_width = function(){
			return __.slice_width;
		}
		static get_true_height = function(){
			return __.slice_height;
		}	
		static get_origin_offset_x = function() {
			return sprite_get_xoffset(__.sprite) - sprite_get_bbox_left(__.sprite);
		}	
		static get_origin_offset_y = function() {
			return sprite_get_yoffset(__.sprite) - sprite_get_bbox_top(__.sprite);
		}	
		static get_draw_sprite_offset_x = function() {
			 // Subtract one for weird relation between bounding box and origin on sprites
			return (get_origin_offset_x() - 1) * get_total_scale() * get_slice_scale_x();
		}
		static get_draw_sprite_offset_y = function() {
			 // Subtract one for weird relation between bounding box and origin on sprites
			return (get_origin_offset_y() - 1) * get_total_scale() * get_slice_scale_y();
		}
		static get_slice_scale_x = function() {
			return get_true_width() / sprite_get_width(__.sprite);
		}
		
		/// @ignore
		static get_slice_scale_y = function() {
			return get_true_height() / sprite_get_height(__.sprite);
		}
		
		/// @ignore
		static draw_component = function() {
			draw_sprite_ext(__.sprite, __.image_index, get_draw_x(), get_draw_y(), get_slice_scale_x(), get_slice_scale_y(), 0, c_white, 1);
		}
		#endregion
		
	#endregion
	
	// Public =================================================================
	
		// Setters
		static set_slice_width = function(_val) {
			__.slice_width = _val;
			update_target_x();
			update_target_y();
			return self;
		}
		static set_slice_height = function(_val) {
			__.slice_height = _val;
			update_target_x();
			update_target_y();
			return self;
		}
		static set_target_slice_width = function(_val) {
			__.target_slice_width = _val;
			return self;
		}
		static set_target_slice_height = function(_val) {
			__.target_slice_height = _val;
			return self;
		}
		static set_velocity_slice_width = function(_val) {
			__.velocity_slice_width = _val;
			return self;
		}
		static set_velocity_slice_height = function(_val) {
		__.velocity_slice_height = _val;
		return self;
	}
			
		// Getters
		static get_slice_width = function(_val) {
			return __.slice_width;
		}
		static get_slice_height = function(_val) {
			return __.slice_height;
		}
		static get_target_slice_width = function(_val) {
			return __.target_slice_width;
		}
		static get_target_slice_height = function(_val) {
			return __.target_slice_height;
		}
		static get_velocity_slice_width = function(_val) {
			return __.velocity_slice_width;
		}
		static get_velocity_slice_height = function(_val) {
			return __.velocity_slice_height;
		}
		
}

