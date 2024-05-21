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
    vec2 translatedCoordinates = (model_uv * 2.0) - 1.0;
    float theta = atan(translatedCoordinates.y, translatedCoordinates.x);
    float radius = pow(length(translatedCoordinates), 1.5);
    vec2 fishEye = vec2(radius * cos(theta), radius * sin(theta));
    FragColor = texture(image, 0.5 * (fishEye + 1.0));
}
