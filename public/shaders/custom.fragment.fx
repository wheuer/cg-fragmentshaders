#version 300 es
precision mediump float;

// Input
in vec2 model_uv;

// Uniforms
uniform sampler2D image;
uniform float videoWidth;
uniform float videoHeight;

// Output
out vec4 FragColor;

void main() {
    // We need to apply a gaussain blur to the 9 surronding texels
    // To do this we need a 5x5 subset of texels, there is no 5x5 matix so use an array
    float offsetX = 1.0 / videoWidth;
    float offsetY = 1.0 / videoHeight;
    vec3 texels[25];
    for (int i = 0; i < 5; i++)
    {
        for (int j = 0; j < 5; j++)
        {
            float texelX = model_uv.x - (float(2 - i) * offsetX);
            float texelY = model_uv.y - (float(2 - j) * offsetY);
            texels[i * 5 + j] = texture(image, vec2(texelX, texelY)).rgb;
        }
    }

    // Convert relevant texels to grayscale (i.e. their luminance)
    float texelsGrayscale[25];
    for (int i = 0; i < 25; i++)
    {
        texelsGrayscale[i] = 0.299 * texels[i].x + 0.587 * texels[i].y + 0.114 * texels[i].z;
    }

    // Apply gaussain blur to relevant texels creating the required 3x3 matrix for the current pixel
    // This blurring will be very small as it's only 3x3 kernel but will help a little
    // Could use a 3x3 matrix but we're having so much fun with arrays
    // Gaussain blur 3x3 kernel:
    //      1 2 1
    //      2 4 2
    //      1 2 1
    float blurredTexelsGrayscale[9];
    for (int i = 0; i < 9; i++)
    {
        float sum = 0.0;
        int startingPosition = 6 + ((i / 3) * 5) + (i % 3);
        sum += texelsGrayscale[startingPosition - 6];
        sum += 2.0 * texelsGrayscale[startingPosition - 5];
        sum += texelsGrayscale[startingPosition - 4];
        sum += 2.0 * texelsGrayscale[startingPosition - 1];
        sum += 4.0 * texelsGrayscale[startingPosition];
        sum += 2.0 * texelsGrayscale[startingPosition + 1];
        sum += texelsGrayscale[startingPosition + 4];
        sum += 2.0 * texelsGrayscale[startingPosition + 5];
        sum += texelsGrayscale[startingPosition + 6];
        blurredTexelsGrayscale[i] = sum / 16.0;
    }

    // Apply sobel operators
    float horizontalSobel = blurredTexelsGrayscale[0] - blurredTexelsGrayscale[2] + 2.0 * blurredTexelsGrayscale[3] - 2.0 * blurredTexelsGrayscale[5] + blurredTexelsGrayscale[6] - blurredTexelsGrayscale[8];
    float verticalSobel = blurredTexelsGrayscale[0] + 2.0 * blurredTexelsGrayscale[1] + blurredTexelsGrayscale[2] - blurredTexelsGrayscale[6] - 2.0 * blurredTexelsGrayscale[7] - blurredTexelsGrayscale[8]; 

    // Calculate magnitude of edge (the final grayscale pixel color)
    float magnitude = length(vec2(horizontalSobel, verticalSobel));

    // Apply a thredhold on the edges to get rid of some of the noise
    if (magnitude > 0.25)
    {
        FragColor = vec4(magnitude, magnitude, magnitude, 1.0);
    }
    else
    {
        FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
