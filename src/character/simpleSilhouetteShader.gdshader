shader_type spatial;

render_mode unshaded, depth_test_inverted, depth_draw_never;

uniform vec4 outline_color : source_color = vec4(1.0, 0.85, 0.0, 0.2); // Yellow

void fragment() {
    ALBEDO = outline_color.rgb;
    ALPHA = 0.5;
}