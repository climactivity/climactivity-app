shader_type canvas_item;

uniform float radius;

void fragment() {
	float dist_from_center = length(vec2(UV.xy - vec2(0.5,0.5))); 
	COLOR = (dist_from_center > radius) ? vec4(0.0) : texture(TEXTURE,UV) ;
}