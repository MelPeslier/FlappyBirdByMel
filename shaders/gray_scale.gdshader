shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float transparency : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float intensity : hint_range(0.0, 20.0, 0.1) = 3.0;

// pour choisir la couleur dans l'inspecteur, // vec4(1.0) pour blanc
uniform vec4 color : source_color = vec4(1.0);
uniform float red_intensity : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float green_intensity : hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float blue_intensity : hint_range(0.0, 1.0, 0.1) = 1.0;

uniform float scale_of_gray : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 pixelColor = texture(screen_texture, SCREEN_UV);
	
	float brightness = 
		( pixelColor.r * red_intensity 
		+ pixelColor.g * green_intensity
		+ pixelColor.b * blue_intensity
		) / intensity
	;
	
	float a = pixelColor.a * transparency;
	vec4 grayScale = vec4(brightness, brightness, brightness, a);
	
	COLOR = mix(pixelColor, grayScale * color, scale_of_gray);
}