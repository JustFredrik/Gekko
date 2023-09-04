/*=========================================================

Gekko Util : Animation ( INTERNAL )

GekkoAnimations are data containers used by 
GekkoComponents to draw and animate sprites.

They are used internally by Gekko and will
never need to be manually instantiated by
users of the library.

=========================================================*/

function GekkoAnimation(_spr, _starting_frame, _image_speed, _callback) constructor {
	image_index = _starting_frame;
	image_speed = _image_speed;
	sprite = _spr;
	max_frame = array_length(sprite_get_info(sprite).frames);
	callback = _callback;
}