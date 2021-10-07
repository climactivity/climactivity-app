shader_type spatial; 
render_mode depth_test_disable;
uniform vec4 fg: hint_color; 
uniform vec2 center;
uniform float str;
uniform float p;
void fragment() {
	float d = pow(str - distance(vec2(UV.x, UV.y), vec2(center.x, center.y)), p);
	ALBEDO = COLOR.rgb;
	ALPHA = COLOR.a*d;
}