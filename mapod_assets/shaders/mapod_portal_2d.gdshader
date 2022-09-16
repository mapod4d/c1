shader_type canvas_item;

uniform sampler2D noiseMap;
uniform vec4 baseColor : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float speed = 0.03;

void fragment() {
	vec2 circular = vec2(sin(TIME * speed) , cos(TIME * speed));
	float noiseValue = texture(noiseMap, UV + circular).x;
	
	COLOR.rgb = vec3(noiseValue * vec3(baseColor[0], baseColor[1], baseColor[2]));
	COLOR.a = baseColor[3];
}