shader_type canvas_item; 

uniform vec4 fg: hint_color; 
uniform vec4 bg: hint_color; 
uniform float r_inner : hint_range(0, 1.2); 
uniform float r_outer : hint_range(0, 1.2);
uniform vec2 center;
uniform float w; 
uniform float h; 
void fragment() {
	vec4 final_color = bg;
	float aspect = w/h; 
	
	float d = distance(vec2(UV.x * aspect, UV.y), vec2(center.x * aspect, center.y));
	if(d > r_inner && d < r_outer) {
		final_color = fg;
	}
	COLOR = final_color;
}