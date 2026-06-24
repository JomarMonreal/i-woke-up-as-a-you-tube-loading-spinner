shader_type canvas_item;

uniform float brightness : hint_range(0.0, 2.0) = 1.0;
uniform float contrast : hint_range(0.0, 2.0) = 1.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Apply Brightness
    tex_color.rgb *= brightness;
    
    // Apply Contrast
    tex_color.rgb = (tex_color.rgb - 0.5) * contrast + 0.5;
    
    // Apply Saturation
    float luma = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    tex_color.rgb = mix(vec3(luma), tex_color.rgb, saturation);
    
    COLOR = tex_color;
}
