shader_type spatial;

uniform vec4 first_color:hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 second_color:hint_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float frequency_multiplier = 4;

void fragment() {
	if(sin(TIME * frequency_multiplier) > 0.0) {
		ALBEDO = first_color.rgb;
		//ALPHA = first_color.a;
	} else {
		ALBEDO = second_color.rgb;
		//ALPHA = second_color.a;
	}
	
	//mix(ALBEDO, color, 1);
}