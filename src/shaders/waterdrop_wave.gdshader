shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

uniform float force: hint_range(0., .1) = 0.;
uniform float radius: hint_range(0., 1.) = 0.;

void fragment() {
	vec2 centre = vec2(.5, .5);
	vec2 current_uv = SCREEN_UV;

	float dist = distance(current_uv, centre);

	if (dist < radius) {
		float wave = sin((dist - radius) * 40.) * force;
		vec2 dir = normalize(current_uv - centre);
		current_uv += dir * wave;
	}

	COLOR = texture(screen_texture, current_uv);
}