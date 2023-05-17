


function GekkoComponentText(_text, _font, _anchor_point, _anchor_offset_x, _anchor_offset_y, _parent) : GekkoComponentAbstract(_parent, _anchor_point, _anchor_offset_x, _anchor_offset_y) constructor {
	
	#region Private ===========================================================
		__gekko_create_private_struct(self); with(__) {
		font = _font;
		text = _text;
		max_width = noone;
	}
		
		// Method Overrides
		static get_true_width = function(){
			var _tmp = draw_get_font();
			draw_set_font(__.font.get_font());
			var _w = string_width(__.text);
			_w -= __.font.get_character_seperation();
			draw_set_font(_tmp);
			return _w;
		}
		static get_true_height = function(){
			return sprite_get_bbox_bottom(__.font.get_sprite()) - sprite_get_bbox_top(__.font.get_sprite());
		}		
		static get_bbox_left = function(){
			return get_x();
		}
		static get_bbox_right = function(){
			return get_x() + get_width();
		}
		static get_bbox_top = function(){
			return get_y();
		}
		static get_bbox_bottom = function(){
			return get_y() + get_height();
		}
		static get_origin_offset_x = function() {
			return 0;
		}
		static get_origin_offset_y = function() {
			return 0;
		}
		static draw_component = function() {
			var _tmp = draw_get_font();
			draw_set_font(__.font.get_font());
			draw_text(get_draw_x(), get_draw_y() - sprite_get_bbox_top(__.font.get_sprite()), __.text);
			draw_set_font(_tmp);
		}
		static draw_debug = function() {
			draw_bounding_box();
			draw_pos();
		}

	#endregion
	
	// Public =================================================================
		
		// Setters
		static set_font = function(_font) {
		if is_struct(_font){
			__.font = _font;
		} else if is_string(_font) && gekko_font_exists(_font){
			__.font = gekko_font_get(_font);
		}
		return self;
	}
		static set_text = function(_text) {
		_text = string(_text);
		
		var _prev_width = get_width();
		__.text = _text;

		var _w = get_width();
	
		switch(gekko_get_alignment_horizontal(__.component_alignment)){
			case GEKKO_COMPONENT_ALIGNMENT_X.LEFT:
				return self;
			case GEKKO_COMPONENT_ALIGNMENT_X.CENTER:
				__.x -= (_w - _prev_width) / 2;
				return self;
				
			case GEKKO_COMPONENT_ALIGNMENT_X.RIGHT:
				__.x -= (_w - _prev_width);
				return self;
		}

		return self;
	}
	
		// Getters
		static get_font = function() {
			return __.font;
		}
		static get_text = function() {
			return __.text;
		}
			
}

