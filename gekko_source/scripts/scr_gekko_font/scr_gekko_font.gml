/*=========================================================

Gekko Util : Font

GekkoFonts wraps default gamemaker sprite fonts
to provide Gekko-like seter and geter interfaces.

=========================================================*/

function GekkoFont(_name ,_font, _sprite, _first_character, _prop, _character_seperation) constructor {
	
	#region Private ===========================================================
	
	__name					= _name;
	__font					= _font;
	__sprite				= _sprite;
	__first_character		= _first_character;
	__proportional			= _prop;
	__character_seperation	= _character_seperation;
	
	#endregion
	
	// Public =================================================================
	
		#region Getters =======================================
	
		///@desc Get the string name representation of the GekkoFont.
		///@context	GekkoFont
		///@return	{String}	font_name
		static get_name = function() {
			return self.__name;
		} 
	
		///@desc Get the wrapped GameMaker font asset.
		///@context	GekkoFont
		///@return	{Asset.GMFont}	font_asset
		static get_font = function() {
			return self.__font;
		} 
	
		///@desc Get the sprite that makes up the font
		///@context	GekkoFont
		///@return	{Asset.GMSprite}	font_sprite
		static get_sprite = function() {
			return self.__sprite;
		}
	
		///@desc Gets if the font is proportional (true) or not (false).
		///@context	GekkoFont
		///@return	{Bool}	is_font_proportional
		static get_proportional = function() {
			return self.__proportional;
		}
	
		///@desc Gets the character seperation value of the font.
		///@context	GekkoFont
		///@return	{Real}	character_seperation
		static get_character_seperation = function() {
			return self.__character_seperation;
		}
	
		#endregion
}

#region Set up default font macro
	global.gekko_font_default = gekko_font_create("Gekko Default Font", gekko_spr_font_small, ord(" "), true, 2);
	#macro GEKKO_FONT_DEFAULT global.gekko_font_default
#endregion