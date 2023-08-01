/*=========================================================

Gekko Component : Sprite

This is a component for drawing GameMaker sprites.

=========================================================*/

function GekkoComponentSprite(_sprite_index, _image_index, _anchor_point, _anchor_offset_x, _anchor_offset_y, _parent) : GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private =====================================================================
		__gekko_create_private_struct(self); with(__) {
		sprite = _sprite_index;
		image_index = _image_index;
		image_speed = 1;
		animation_queue = [];
	}
		
		// Parent Method Overrides
		static get_true_width = function(){
			var _s = get_sprite();
			return sprite_get_bbox_right(_s) - sprite_get_bbox_left(_s);
		}	
		static get_true_height = function(){
			var _s = get_sprite();
			return sprite_get_bbox_bottom(_s) - sprite_get_bbox_top(_s);
		}	
		static get_draw_origin_offset_x = function() {
			var _s = get_sprite();
			return sprite_get_xoffset(_s) - sprite_get_bbox_left(_s);
		}
		static get_draw_origin_offset_y = function() {
			var _s = get_sprite();
			return sprite_get_yoffset(_s) - sprite_get_bbox_top(_s);
		}
		static get_draw_sprite_offset_x = function() {
			 // Subtract one for weird relation between bounding box and origin on sprites
			return (get_draw_origin_offset_x()) //* get_total_scale();
		}
		static get_draw_sprite_offset_y = function() {
			 // Subtract one for weird relation between bounding box and origin on sprites
			return (get_draw_origin_offset_y()) //* get_total_scale();
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
	
	// Public ===========================================================================
		
		#region General ===================================
			
			///@desc overrides the current sprite and plays an animation once, then reverts to the default sprite.
			/// If a callback is provided it will be called once the animation has ended. Calling this method multiple times
			/// will result in animation being queued one after another. Setting instant to true will clear the queue and instantly
			/// play the provided animation.
			///@param {Asset.GMSprite} sprite_index
			///@param {Real} starting_frame
			///@param {Real} image_speed
			///@param {Bool} instant
			///@param {Function} callback
			///@self GekkoComponentSprite
			///@return {Struct.GekkoComponentText} self
			static play_animation = function(_sprite, _starting_frame=0, _image_speed = 1, _instant=false, _callback=noone) {
				if _instant { __.animation_queue = []; }
				array_push(__.animation_queue, new GekkoAnimation(_sprite, _starting_frame, _image_speed, _callback));
				return self;
			} 
			
		#endregion
		
		#region Setters ===================================
		
		///@desc Sets the sprite for the component
		///@param {Asset.GMSprite} sprite_index
		///@param {Real} image_index
		///@param {Real} image_speed
		///@self GekkoComponentSprite
		///@return {Struct.GekkoComponentText} self
		static set_sprite = function( _spr, _sub_img = undefined , _image_speed = undefined ) {
			__.sprite = _spr;
			if _sub_img		!= undefined { set_image_index(_sub_img); }
			if _image_speed != undefined { set_image_speed(_image_speed); }
			return self;
		}
		
		///@desc Sets the image-index for the component
		///@param {Real} image_index
		///@self GekkoComponentSprite
		///@return {Struct.GekkoComponentText} self
		static set_image_index = function(_sub_image) {
			__.image_index = _sub_image;
			return self;
		}
		
		///@desc Sets the image-speed for the component
		///@param {Real} image_speed
		///@self GekkoComponentSprite
		///@return {Struct.GekkoComponentText} self
		static set_image_speed = function(_spd) {
			__.image_speed = _spd;
			return self;
		}
		
		#endregion
		
		#region Getters ===================================
		
		///@desc Gets the sprite for the component
		///@self GekkoComponentSprite
		///@return {Asset.GMSprite} sprite_index
		static get_sprite = function() {
			if array_length(__.animation_queue) > 0 {
				return __.animation_queue[0].sprite;
			}
			return __.sprite;
		}
			
		///@desc Gets the image_index for the component
		///@self GekkoComponentSprite
		///@return {Real} image_index	
		static get_image_index = function() {
			if array_length(__.animation_queue) > 0 {
				return __.animation_queue[0].image_index;
			}
			return __.image_index;
		}
			
		///@desc Gets the image_speed for the component
		///@self GekkoComponentSprite
		///@return {Real} image_speed
		static get_image_speed = function() {
			return __.image_speed;
		}
			
		#endregion

}
