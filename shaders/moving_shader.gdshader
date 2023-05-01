shader_type canvas_item;

uniform float speed : hint_range(0.0, 1.0, 0.01) = 0.1;


void fragment() {
	vec4 texture_color = texture(TEXTURE, UV + vec2(speed, 0) * TIME);
	COLOR = texture_color;
}
