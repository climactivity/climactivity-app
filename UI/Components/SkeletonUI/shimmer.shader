
// TODO clean up
shader_type canvas_item; 
render_mode unshaded;
uniform vec4 base_color: hint_color = vec4(1.0,1.0,1.0,1.0); 
uniform vec4 highlight_color: hint_color = vec4(0.0,1.0,1.0,1.0); 
uniform float speed = 1.0;
uniform float direction = 45.0;
uniform float lower_edge = 0.5; 
uniform float upper_edge = 0.5; 
uniform float period = 10;
uniform bool flip = true;
uniform vec2 u_resolution = vec2(600, 600);


float waves(float time, float x, float y, float s) {
	float h = smoothstep(lower_edge,upper_edge
			,abs(sin(
					 (s * time) 
					 + ((x+y*radians(direction))
					 * period
					)
				))
	);
	return h;
}

float speedMod(float s, float t) {
	float b = t * s + sin(t);
	return b;
}

void fragment() {

	vec2 st = flip ? SCREEN_UV.xy : -SCREEN_UV.xy;
	//vec2 st = vec2(flip? SCREEN_UV.x : -SCREEN_UV.x,flip? SCREEN_UV.y : -SCREEN_UV.y);
	float fg_strength = waves(TIME, st.x, st.y, speed);
	COLOR = mix(base_color, highlight_color, fg_strength);
	//COLOR = vec4(fg_strength,0.0,0.0,1.0);
}