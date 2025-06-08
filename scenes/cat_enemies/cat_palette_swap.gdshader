shader_type canvas_item;

uniform float numColours;
uniform sampler2D palette;

void fragment() {
    vec4 textureColour = texture(TEXTURE, UV); // get pixel colour of cat (greyscale)
	float colorMap = textureColour.r; // greyscale value is used to refer to the palette

	vec4 paletteColour = texture(palette, vec2((2.0*numColours-1.0)/numColours, 0.5)); // y-coord doesn't really matter
	vec4 finalColour = texture(palette, vec2(textureColour.r, textureColour.g));

	finalColour.a = textureColour.a; // keep alpha value from the original cat
	COLOR = finalColour;
}