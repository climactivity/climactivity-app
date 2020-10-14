shader_type canvas_item; 

uniform sampler2D gradient; 

void fragment() {
	COLOR = texture(gradient, vec2(UV.y, 0));
	//COLOR = vec4(UV.y,0,0,1);
}