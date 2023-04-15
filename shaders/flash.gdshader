shader_type canvas_item;

uniform vec4 flashColor : source_color = vec4(1.0);

uniform float flashState : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 colorPixel = texture(TEXTURE, UV);
	COLOR = mix(colorPixel, flashColor, flashState);
	COLOR.a *= colorPixel.a;
}
