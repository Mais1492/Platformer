shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled;

uniform vec4 line_color : source_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform float line_thickness : hint_range(0.0, 10.0) = 2.0;
uniform float opacity : hint_range(0.0, 1.0) = 0.7;

// Barycentric wireframe (works on most models)
varying vec3 barycentric;

void vertex() {
    // Pass barycentric coordinates
    barycentric = vec3(0.0);
    if (VERTEX_ID % 3 == 0) barycentric.x = 1.0;
    else if (VERTEX_ID % 3 == 1) barycentric.y = 1.0;
    else barycentric.z = 1.0;
}

void fragment() {
    // Calculate distance to nearest edge
    vec3 d = fwidth(barycentric);
    vec3 a3 = smoothstep(vec3(0.0), d * line_thickness, barycentric);
    float edge = 1.0 - min(min(a3.x, a3.y), a3.z);
    
    // Output wireframe
    ALBEDO = line_color.rgb;
    ALPHA = edge * opacity;
    
    // Always draw on top
    DEPTH = 1.0;
}