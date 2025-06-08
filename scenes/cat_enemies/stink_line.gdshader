shader_type canvas_item;

uniform float final_alpha : hint_range(0.0, 1.0) = 1.0; // Controls transparency

void fragment() {
	vec4 orig_color = texture(TEXTURE, UV);
	
	float wiggle_speed = 8.0;
	float wiggle = 0.2*(sin(wiggle_speed*(TIME + UV.y)));
	
	vec2 uv_to_sample = UV + vec2(wiggle, 0.0);
	vec4 color = texture(TEXTURE, uv_to_sample);
	
	 COLOR = vec4(color.rgb, color.a * final_alpha);
}
