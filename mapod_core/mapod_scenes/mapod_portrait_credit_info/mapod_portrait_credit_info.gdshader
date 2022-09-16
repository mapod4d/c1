shader_type spatial;

uniform sampler2D base_texture : hint_albedo;
uniform vec2 ratio = vec2(1.0);
uniform vec2 offset = vec2(0.0);
uniform float rotation = 0;

void fragment() {
    //ALBEDO = vec3(1.0, 0.0, 0.0);
	
	//vec4 color = texture(base_texture, vec2(UV.x*2.0, UV.y*2.0));
	//ALBEDO = vec3(color.r, color.g, color.b);
	
	//mat2 rotation_matrix=mat2(vec2(sin(degrees(rotation)),-cos(degrees(rotation))),
    //                          vec2(cos(degrees(rotation)),sin(degrees(rotation))));
	//mat2 rotation_matrix=mat2(vec2(sin(rotation),-cos(rotation)),
    //                          vec2(cos(rotation),sin(rotation)));
	//mat2 rotation_matrix=mat2(vec2(-1.0,0.0), vec2(0.0,1.0));
	//mat2 rotation_matrix=mat2(vec2(sin(radians(90.0)),-cos(radians(90.0))),
    //                          vec2(cos(radians(90.0)),sin(radians(90.0))));
	mat2 rotation_matrix=mat2(vec2(cos(radians(rotation)),sin(radians(rotation))),
                              vec2(-sin(radians(rotation)),cos(radians(rotation))));
	//vec2 uv = UV - 0.5;
	//uv = uv * rotation_matrix;
	//uv = uv + 0.5;
	//uv = uv * ratio - offset;
	//vec2 uv = (UV - 0.5) * rotation_matrix;
	//uv += 0.5;
	//uv = uv * vec2(1.0/ratio.y, 1.0/ratio.x) - vec2(-offset.y, -offset.x);
	vec2 i_ratio = vec2(1.0/ratio.y, 1.0/ratio.x);
	vec2 i_offset = vec2(-offset.y, -offset.x);
	vec2 pivot = vec2(i_ratio.x/2.0, i_ratio.y/2.0);
	
	vec2 uv = UV * i_ratio;
	uv -= pivot;
	uv = uv * rotation_matrix;
	uv += pivot * rotation_matrix;
	uv -= i_offset * rotation_matrix;
	ALBEDO = texture(base_texture, uv).rgb;
}