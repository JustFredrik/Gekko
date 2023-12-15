/*=========================================================

Gekko Util : Enums

A wide range of different enums used by developers and
intenrally by Gekko.

=========================================================*/

// Used to describe anchor points for components.
enum GEKKO_ANCHOR {
	NONE,
	TOP_LEFT,
	TOP_CENTER,
	TOP_RIGHT,
	MID_LEFT,
	MID_CENTER,
	MID_RIGHT,
	BOT_LEFT,
	BOT_CENTER,
	BOT_RIGHT
}

// Used to describe the direction of Gekko List components.
enum GEKKO_LIST_DIRECTION {
	HORIZONTAL,
	VERTICAL
}

// Used to describe the horizontal aspect of the anchor point for components.
enum GEKKO_ANCHOR_HORIZONTAL {
	LEFT,
	CENTER,
	RIGHT
}

// Used to describe the vertical aspect of the anchor point for components.
enum GEKKO_ANCHOR_VERTICAL {
	TOP,
	MID,
	BOT
}

// Used to describe how components should align themselves relative to their anchor point.
enum GEKKO_COMPONENT_ALIGNMENT {
	TOP_LEFT,
	TOP_CENTER,
	TOP_RIGHT,
	MID_LEFT,
	MID_CENTER,
	MID_RIGHT,
	BOT_LEFT,
	BOT_CENTER,
	BOT_RIGHT,
	ORIGIN
}

// Used to describe the x component of how components should align themselves relative to their anchor point.
enum GEKKO_COMPONENT_ALIGNMENT_X {
	LEFT,
	CENTER,
	RIGHT,
	ORIGIN
}

// Used to describe the y component of how components should align themselves relative to their anchor point.
enum GEKKO_COMPONENT_ALIGNMENT_Y {
	TOP,
	MID,
	BOT,
	ORIGIN
}

// Used to describe the type a component is.
enum GEKKO_TYPE {
	ABSTRACT,
	SPRITE,
	LIST,
	WRAPPER,
	TEXT,
	UTIL_FONT,
	UTIL_SPRING
}

// Used to describe the animation style that a component or a specific property in a component should use.
enum GEKKO_ANIMATION_STYLE {
	INSTANT,
	LERP,
	SPRING
}
	
// Used by lists to align thier children.
enum GEKKO_CHILD_ALIGNMENT {
	HORIZONTAL,
	VERTICAL
}


enum GEKKO_COMPONENT_EVENT {
	SET_SCALE,
	SET_X,
	SET_Y,
	SET_ANCHOR,
	DIM_CHANGE,
	SET_OFFET_ABSOLUTE,
	PROPERTY_CHANGE,
	SET_VISIBLE,
	CLICK,
	TAP,
	DESTROY
}