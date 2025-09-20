shader_type canvas_item;

uniform float dissolve = 0.0;
uniform sampler2D noise_texture;

void fragment() {
	float dither = texture(noise_texture, SCREEN_UV).r;
	float alpha = step(dither, dissolve);
	COLOR = vec4(vec3(0.0), alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
