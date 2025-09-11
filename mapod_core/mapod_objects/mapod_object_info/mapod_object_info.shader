shader_type spatial;

vec3 mapod_color(float time) {
 float value = cos(time * 1.0);
 return vec3(value, value, 0.0);
}

void fragment() {
  RIM = 0.2;
  METALLIC = 0.0;
  ROUGHNESS = 0.01;
  ALBEDO = mapod_color(TIME);
}