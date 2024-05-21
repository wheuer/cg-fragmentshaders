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
    vec3 textureColor = texture(image, model_uv).rgb;
    float luminance = 0.299 * textureColor.x + 0.587 * textureColor.y + 0.114 * textureColor.z;
    FragColor = vec4(luminance, luminance, luminance, 1.0);
}
