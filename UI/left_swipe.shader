shader_type canvas_item; 

uniform vec4 fg_color : hint_color;
uniform vec4 bg_color : hint_color;

uniform float fg_progress : hint_range(0.0,1.0); 
uniform float bg_progress : hint_range(0.0,1.0); 

uniform float w; 
uniform float h; 

void fragment() {
	float aspect = w/h; 
	vec4 final_color = bg_color + (step(1.0 - UV.x, fg_progress) - step(1.0 - UV.x, bg_progress))  * fg_color;
	
	COLOR = final_color;
}
