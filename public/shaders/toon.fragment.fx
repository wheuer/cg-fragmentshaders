#version 300 es
precision mediump float;

// Input
in vec2 model_uv;

// Uniforms
uniform sampler2D image;

// Output
out vec4 FragColor;

void main() {
    // Color
    vec3 baseColor = texture(image, model_uv).rgb;
    vec3 quantizedColor = round(baseColor * 4.0) / 4.0;
    FragColor = vec4(quantizedColor, 1.0);
}
