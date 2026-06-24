shader_type canvas_item;

uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec2 shadow_offset = vec2(4.0, 4.0);   // pixels, positive = shadow from top-left
uniform float shadow_size : hint_range(1.0, 32.0) = 6.0;  // softness / spread in pixels

void fragment() {
	vec4 original = texture(TEXTURE, UV);

	// accumulate samples along the shadow direction from the edge inward
	float shadow = 0.0;
	for (float i = 1.0; i <= shadow_size; i += 1.0) {
		float t = i / shadow_size;
		vec2 sample_uv = UV - shadow_offset * TEXTURE_PIXEL_SIZE * t;
		float outside = 1.0 - texture(TEXTURE, sample_uv).a;
		shadow += outside * (1.0 - t);  // farther samples contribute less
	}

	shadow = clamp(shadow / shadow_size * 2.0, 0.0, 1.0);
	shadow *= original.a;  // only inside the shape

	vec3 col = mix(original.rgb, shadow_color.rgb, shadow * shadow_color.a);
	COLOR = vec4(col, original.a);
}
