shader_type spatial;
render_mode skip_vertex_transform, unshaded; //Important, we want to adjust it manually

uniform float y_axis = -0.3;
uniform vec4 color: source_color;

uniform sampler2D albedo_texture;
uniform vec4 albedo_color;
uniform float roughness: hint_range(0.0, 1.0);
uniform float metallic: hint_range(0.0, 1.0);

void fragment() {
    vec4 albedo = texture(albedo_texture, UV) * albedo_color;
    ALBEDO = albedo.rgb;
    ROUGHNESS = roughness;
    METALLIC = metallic;
}

float remap(float value, float i_min, float i_max, float o_min, float o_max) {
    return o_min + ((value - i_min) / (i_max - i_min) * (o_max - o_min));
}

void vertex(){
	//Work in viewspace
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float sq_distance = VERTEX.z * VERTEX.z;
	VERTEX.y += remap(y_axis,-1.0,1.0,-0.015,0.015) * sq_distance;
}

