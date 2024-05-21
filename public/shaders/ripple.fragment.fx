#version 300 es
precision mediump float;

// Input
in vec2 model_uv;

// Uniforms
uniform sampler2D image;
uniform float time;

// Output
out vec4 FragColor;

void main() {
    // Color
    vec2 translatedCoordinates = (model_uv * 2.0) - 1.0;
    float radius = length(translatedCoordinates);
    vec2 offset = translatedCoordinates * (sin(radius * 30.0 - time * 5.0) + 0.5) / 60.0;
    FragColor = texture(image, vec2(model_uv.x + offset.x, model_uv.y + offset.y));
}
