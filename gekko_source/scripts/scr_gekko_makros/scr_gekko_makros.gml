
// Gekko Meta Data
#macro GEKKO_LIBRARY_NAME "Gekko UI"
#macro GEKKO_VERSION_NUMBER "0.0.1"
#macro GEKKO_GITHUB_URL "https://github.com/JustFredrik/Gekko"
#macro GEKKO_VERSION GEKKO_LIBRARY_NAME + " " + GEKKO_VERSION_NUMBER

// Shader Types
#macro GEKKO_INT			0
#macro GEKKO_FLOAT			1
#macro GEKKO_INT_ARRAY		2
#macro GEKKO_FLOAT_ARRAY	3
#macro GEKKO_MATRIX			4
#macro GEKKO_MATRIX_ARRAY	5

// Default spring
global.gekko_spring_default = new GekkoSpring();
#macro GEKKO_SPRING_DEFAULT global.gekko_spring_default
