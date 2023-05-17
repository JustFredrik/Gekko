function GekkoComponentSprite(_sprite_index, _image_index, _anchor_point, _anchor_offset_x, _anchor_offset_y, _parent) : GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private ===========================================================
		__gekko_create_private_struct(self); with(__) {
		sprite = _sprite_index;
		image_index = _image_index;
		image_speed = 1;
		animation_queue = [];
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
			draw_sprite_ext(get_sprite(), get_image_index(), get_draw_x() + get_draw_sprite_offset_x(), get_draw_y() + get_draw_sprite_offset_y(), 1, 1, 0, get_color(), 1);
		}
		static __component_special_update = function() {
			__.image_index += __.image_speed;
			var _anim_len = array_length(sprite_get_info(__.sprite).frames);
			if __.image_index >= _anim_len{
				__.image_index -= _anim_len;
			}	
			
			// Update Animation Queue
			if array_length(__.animation_queue) > 0{
				var _anim = __.animation_queue[0];
				_anim.image_index += _anim.image_speed;
				
				if (_anim.image_index >= _anim.max_frame){
					array_delete(__.animation_queue, 0, 1);
					if _anim.callback != noone { _anim.callback(); }
				}
			}
		}
	#endregion
	
	// Public =================================================================
	
		// Setters
		static set_sprite = function( _spr, _sub_img = undefined , _image_speed = undefined ) {
			__.sprite = _spr;
			if _sub_img		!= undefined { set_image_index(_sub_img); }
			if _image_speed != undefined { set_image_speed(_image_speed); }
			return self;
		}
		static set_image_index = function(_sub_image) {
			__.image_index = _sub_image;
			return self;
		}
		static set_image_speed = function(_spd) {
			__.image_speed = _spd;
			return self;
		}
		static play_animation = function(_sprite, _starting_frame=0, _image_speed = 1, _instant=false, _callback=noone) {
			if _instant { __.animation_queue = []; }
			array_push(__.animation_queue, new GekkoAnimation(_sprite, _starting_frame, _image_speed, _callback));
			return self;
		} 
			
		// Getters
		static get_sprite = function() {
			if array_length(__.animation_queue) > 0 {
				return __.animation_queue[0].sprite;
			}
			return __.sprite;
		}
		static get_image_index = function() {
			if array_length(__.animation_queue) > 0 {
				return __.animation_queue[0].image_index;
			}
			return __.image_index;
		}
		static get_image_speed = function() {
			return __.image_speed;
		}

}

function GekkoAnimation(_spr, _starting_frame, _image_speed, _callback) constructor {
	image_index = _starting_frame;
	image_speed = _image_speed;
	sprite = _spr;
	max_frame = array_length(sprite_get_info(sprite).frames);
	callback = _callback;
}