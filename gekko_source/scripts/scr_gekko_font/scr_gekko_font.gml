
global.gekko_font_default = gekko_font_create("Gekko Default Font", gekko_spr_font_small, ord(" "), true, 2);
#macro GEKKO_FONT_DEFAULT global.gekko_font_default


function gekko_font_create(_name ,_sprite, _first_character, _prop, _character_seperation) {
	var _gm_font = font_add_sprite(_sprite, _first_character, _prop, _character_seperation);
	var _m = __gekko_get_manager();
	var _gekko_font = new GekkoFont(_name, _gm_font, _sprite, _first_character, _prop, _character_seperation);
	
	_m.font_map[? _name] = _gekko_font;
	
	return _gekko_font;
}


function GekkoFont(_name ,_font, _sprite, _first_character, _prop, _character_seperation) constructor {
	__name					= _name;
	__font					= _font;
	__sprite				= _sprite;
	__first_character		= _first_character;
	__proportional			= _prop;
	__character_seperation	= _character_seperation;
	
	static get_name = function() {
		return self.__name;
	} 
	
	static get_font = function() {
		return self.__font;
	} 
	
	static get_sprite = function() {
		return self.__sprite;
	}
	
	static get_proportional = function() {
		return self.__proportional;
	}
	
	static get_character_seperation = function() {
		return self.__character_seperation;
	}
}

function gekko_font_get(_name) {
	if is_struct(_name){ return _name } // If name is already a struct just return it
	
	var _m = __gekko_get_manager();
	if ds_map_exists(_m.font_map, _name) {
		return _m.font_map[? _name];
	}
}


function gekko_font_exists(_font_name) {
	var _m = __gekko_get_manager();
	return ds_map_exists(_m.font_map, _font_name);
}


function gekko_font_get_names() {
	var _m = __gekko_get_manager();
	return ds_map_keys_to_array(_m.font_map);
}

