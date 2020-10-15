shader_type canvas_item;

uniform float radius = 5.0;
uniform float x = 0.0;
uniform float y = 0.0;
uniform vec4 shadow_color: hint_color;
void fragment(){
    vec2 px = TEXTURE_PIXEL_SIZE;
    float total_alpha = 0.0;

    for(float h = (radius - 1.0) * -1.0; h < radius; h++){
        for(float v = (radius - 1.0) * -1.0; v < radius; v++){
            if(length(vec2(h, v)) > radius) continue;
            total_alpha += texture(TEXTURE, UV + px * vec2(h - x, v - y)).a;
        }
    }
	
    float alpha_ratio = total_alpha / (radius * radius );
	vec4 color = texture(TEXTURE, UV);
	
    COLOR = mix(color, shadow_color, clamp(1.0 - alpha_ratio, 0.0, 1.0));
	COLOR.a = 1.0 - clamp(1.0 - alpha_ratio, 0.0, 1.0);
}