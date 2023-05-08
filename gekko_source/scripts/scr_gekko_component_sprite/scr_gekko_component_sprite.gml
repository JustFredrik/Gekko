function GekkoComponentSprite(_sprite_index, _image_index, _anchor_point, _anchor_offset_x, _anchor_offset_y, _parent) : GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private ===========================================================
		__gekko_create_private_struct(self); with(__) {
		sprite = _sprite_index;
		image_index = _image_index;
	}
		
		// Parent Method Overrides
		static get_true_width = function(){
			return sprite_get_bbox_right(__.sprite) - sprite_get_bbox_left(__.sprite);
		}	
		static get_true_height = function(){
			return sprite_get_bbox_bottom(__.sprite) - sprite_get_bbox_top(__.sprite);
		}	
		static get_origin_offset_x = function() {
			return sprite_get_xoffset(__.sprite) - sprite_get_bbox_left(__.sprite);
		}
		static get_origin_offset_y = function() {
			return sprite_get_yoffset(__.sprite) - sprite_get_bbox_top(__.sprite);
		}
		static get_draw_sprite_offset_x = function() {
			 // Subtract one for weird relation between bounding box and origin on sprites
			return (get_origin_offset_x() - 1) * get_total_scale();
		}
		static get_draw_sprite_offset_y = function() {
			 // Subtract one for weird relation between bounding box and origin on sprites
			return (get_origin_offset_y() - 1) * get_total_scale();
		}
		static draw_component = function() {
			draw_sprite(__.sprite, __.image_index, get_draw_x() + get_draw_sprite_offset_x(), get_draw_y() + get_draw_sprite_offset_y());
		}
	#endregion
	
	// Public =================================================================
	
		// Setters
		static set_sprite = function( _spr, _sub_img = undefined ) {
			__.sprite = _spr;
			if _sub_img != undefined {
				set_image_index(_sub_img);
			}
			return self;
		}
		static set_image_index = function(_sub_image) {
			__.image_index = _sub_image;
			return self;
		}
			
		// Getters
		static get_sprite = function() {
			return __.sprite;
		}
		static get_image_index = function() {
			return __.image_index;
		}

}

